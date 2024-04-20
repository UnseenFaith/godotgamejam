extends Node2D

var menu_system
var cur_tweener
var active_level

# controls whether we can hit start -- needed to prevent folks\
# spamming start and jumping levels
var _can_start = true

@export var levels = [
	preload('res://nodes/scenes/Main1.tscn'),
	preload('res://nodes/scenes/Main2.tscn'),
	preload('res://nodes/scenes/Main3.tscn'),
]

var cur_level = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Jukebox.get_player())
	menu_system = preload('res://nodes/ui/menu_system.tscn').instantiate()
	add_child(menu_system)

	menu_system.start_game.connect(_game_start)
	menu_system.quit_game.connect(_game_exit)

func _game_exit():
	get_tree().quit()

@onready var _curtain = $CanvasLayer/Curtain
@onready var _level_summary = $CanvasLayer/LevelSummary

# next: ?Callable
func _curtain_in(next):
	cur_tweener = get_tree().create_tween()
	cur_tweener.tween_property(
		_curtain,
		"modulate",
		_color_fade_out,
		1.5)
	if next != null:
		cur_tweener.tween_callback(next)

# next: ?Callable
func _curtain_out(next):
	cur_tweener = get_tree().create_tween()
	cur_tweener.tween_property(_curtain, 'modulate', _color_fade_in, 1.5)
	#cur_tweener.tween_property(_curtain, 'modulate', _color_fade_in, 1)
	if next != null:
		cur_tweener.tween_callback(next)

var max_level = 0

# handles button presses so we can filter out spamming the start button
func _game_start():
	if not _can_start:
		return
	_can_start = false
	cur_level = max_level
	_curtain_in(_load_level)

var _color_fade_out = Color(0, 0, 0, 1)
var _color_fade_in = Color(0, 0, 0, 0)

# loads whatever level is referenced by cur_level
func _load_level():
	_level_summary.visible = false
	# remove the currently active level if there is one
	if active_level != null:
		remove_child(active_level)
	cur_tweener = null

	active_level = levels[cur_level].instantiate()
	add_child(active_level)
	menu_system.visible = false
	menu_system.modulate = Color.WHITE
	active_level.get_node('Hud').level_completed.connect(_level_completed)

	_curtain_out(_level_fade_in_completed)
	Jukebox.play_bg()

func _load_menu():
	_level_summary.visible = false
	if active_level != null:
		remove_child(active_level)
	
	menu_system.visible = true
	menu_system.modulate = Color.WHITE
	_can_start = true
	_curtain_out(null)
	Jukebox.play_title()

func _get_tutorial_type():
	match cur_level:
		0:
			return Enums.TutorialCard.SHIELD
		1:
			return Enums.TutorialCard.SWORD
		2:
			return Enums.TutorialCard.STAFF
		_:
			assert(false)

func _level_fade_in_completed():
	cur_tweener = null
	$CanvasLayer/TutorialCard.setup(_get_tutorial_type())
	$CanvasLayer/TutorialCard.visible = true

func _tutorial_card_clear():
	$CanvasLayer/TutorialCard.visible = false
	active_level.start_level()

func _level_completed(score: int, orders_filled: int, orders_missed: int):
	if cur_level == levels.size() - 1:
		_level_summary._credits_next = true
	_level_summary.setup(score, active_level.score_limits, orders_filled, orders_missed)
	_level_summary.visible = true
	active_level.get_node('Hud').visible = false
	if active_level != null:
		active_level.end_level()

func _summary_progress(typ: Enums.ProgressType):
	match typ:
		Enums.ProgressType.RETRY:
			pass
		Enums.ProgressType.NEXT_LEVEL:
			cur_level += 1
		Enums.ProgressType.CREDITS:
			_summary_menu()
			return

	if cur_level > max_level:
		max_level = cur_level

	_curtain_in(_load_level)

func _summary_menu():
	_curtain_in(_load_menu)
