extends Node2D

signal end_credits

var initial_speed = 175
var speed = 175
var line_height_px = 10
var _space_color = Color(0, 0.098, 0.157)

@onready var _dlg = $Container/Blacksmith/Dialoge
@onready var _dlg_text = $Container/Blacksmith/Dialoge/Mask/Text
@onready var _blacksmith = $Container/Blacksmith
#@onready var _dlg_text = $Blacksmith/Dialoge/Text

var _reversed = false
func _anim(dir: String, rev: bool = false):
	_blacksmith.play(dir)
	_reversed = rev

func _stop():
	_blacksmith.stop()

var _bs_tween

var bart_scr = [
	func(): _speak_clear(),
	func(): _anim('east'),
	3000,
	func(): _anim('south_east'),
	250,
	func(): _anim('south'),
	350,
	func(): _anim('idle_south'),
	func(): _stop(),
	500,
	func(): _speak(blurb[0]), # hi
	1250,
	func(): _speak(blurb[1]), # I'm bart
	3750,
	func(): _scroll_dlg(3, 1.5),
	func(): _speak(blurb[2]), # Most folks
	3500,
	func(): _scroll_dlg(5, 2.5),
	2000,
	func(): _speak(blurb[3]), # paid
	2750,
	func(): _speak_clear(),
	func(): _speak(blurb[4]),
	1000,
	func(): _speak(blurb[5]),
	2500,
	func(): _speak(blurb[6]),
	350,
	func(): _start_camera_move(80),
	1500,
	func(): _speak_clear(),
	func(): _speak(blurb[7]),
	500,
	func(): _anim('south', true),
	func(): _set_speed(speed / 8),
	750,
	func(): _speak(blurb[8]),
	1000,
	func(): _anim('idle_south'),
	func(): _stop(),
	func(): _speak(blurb[9]),
	2250,
	func(): _speak_clear(),
	func(): _speak(blurb[10]),
	250,
	func(): _fade_out(_dlg, 1),
	1000,
	func(): _set_speed(initial_speed),
	func(): _play_out_bart(),
	func(): _switch_script(credits_scr)
]

var credits_scr = [
	0, # bug that skips the 0th item after switching a script not worth fixing
	func(): _start_camera_move(40),
	4500,
	func(): _fade_in($Container/Thanks, 3),
	3000,
	func(): _fade_out($Container/Thanks, 2.5),
	6000,
	func(): _fade_in($Container/Dino, 2.5),
	func(): $Container/Stars.emitting = true,
	func(): _start_camera_move(30),
	4000,
	func(): _fade_out($Container/Dino, 2.5),
	func(): _dump_ground(),
	4000,
	func(): _fade_in($Container/Design, 2.5),
	2500,
	func(): _fade_in($Container/Development, 2.5),
	2500,
	func(): _fade_out($Container/Design, 2.5),
	2500,
	func(): _fade_in($Container/Sound, 2.5),
	2500,
	func(): _fade_out($Container/Development, 2.5),
	1750,
	func(): _fade_in($Container/Art, 2.5),
	1750,
	func(): _fade_out($Container/Sound, 2.5),
	2500,
	func(): _fade_out($Container/Art, 2.5),
]

var in_sky = false
func _dump_ground():
	in_sky = true
	$Container.remove_child($Container/Sky)
	$Container.remove_child($Container/Grass)
	$Container.remove_child($Container/Clouds)
	$Container.remove_child($Container/Tree1)
	$Container.remove_child($Container/Tree2)
	$Container.remove_child($Container/Tree3)
	$Container.remove_child($Container/Tree4)
	$Container.remove_child($Container/Tree5)
	$Container.remove_child($Container/Tree6)
	$Container.remove_child($Container/Blacksmith)

func _switch_script(new_scr):
	scr = new_scr
	frame_pointer = 0

func _play_out_bart():
	_anim('south')
	var t = get_tree().create_timer(6)
	t.timeout.connect(func(): _stop())

var blurb = [
	"Hi.\n", # 0
	"My name is Bart. I'm glad you spent\n" + # 1
	"the morning at my smithy. That's right\n" +
	"that was just the morning.\n",
	"Most folks don't realize how hectic\n" + # 2
	"it is to run a smithy. And how under-\n" +
	"appreciated I am.\n\n",
	"And how underpaid.\n\n", # 3
	"Anyway.\n", # 4
	"I'm looking for an apprentice.", # 5
	"I pay in exposure, of course, but you\n" +
	"would get to...", # 6
	"Hey, where are you going?\n", #7
	"Come back!\n", # 8
	". . .\n", # 9
	"*Sigh*", # 10
]

var camera_tweener
func _start_camera_move(time: int):
	if camera_tweener != null:
		camera_tweener.kill()
	camera_tweener = get_tree().create_tween()
	var height = $Container/TopSky.texture.get_height() + $Container/Space.texture.get_height()
	#camera_tweener.tween_property($Container/Camera2D, 'position', Vector2(0, -height), time)
	camera_tweener.tween_property($Container, 'position', Vector2(0, height), time)

func _scroll_dlg(lines: int, sec: float):
	var t = get_tree().create_tween()
	var cxy = _dlg_text.position
	var cy = cxy.y
	t.tween_property(_dlg_text, 'position', Vector2(cxy.x, cy - (lines * line_height_px)), sec)

func _speak_clear():
	_dlg_text.text = ''
	_dlg_text.position.y = -31

func _speak(contents):
	if contents == null:
		_dlg.visible = false
		return
	_dlg.visible = true
	_dlg_text.text += '\n' + contents

func _set_pos(obj, x, y):
	obj.position = Vector2(x, y)

func _set_speed(sp: int):
	speed = sp

func _fade_in(obj, t_sec):
	obj.modulate = Color(Color.WHITE, 0)
	obj.visible = true
	var t = get_tree().create_tween()
	t.tween_property(obj, 'modulate', Color(Color.WHITE, 1), t_sec)

func _fade_out(obj, t_sec):
	var t = get_tree().create_tween()
	t.tween_property(obj, 'modulate', Color(Color.WHITE, 0), t_sec)

func _get_velocity():
	if not _blacksmith.is_playing():
		return Vector2(0, 0)

	var anim = _blacksmith.get_animation()
	var x = 0
	var y = 0

	match anim:
		'east':
			x = 1
		'south':
			y = 1
		'south_east':
			x = 1
			y = 1
		'north':
			y = -1
		'north_east':
			x = 1
			y = -1
		_:
			x = 0
			y = 0
	
	var v = Vector2(x, y).normalized() * speed
	if _reversed:
		v = v * -1
	return v

var frame_pointer = 0
var scr
var _start_credits_ms

# Called when the node enters the scene tree for the first time.
func _ready():
	scr = bart_scr
	_start_credits_ms = Time.get_ticks_msec()
	Jukebox.play_credits()

func _done():
	print('done moving camera')

var _advance_at = 0
func _process_script():
	if frame_pointer >= scr.size():
		return
	var now = Time.get_ticks_msec()
	if now < _advance_at:
		return

	var thing = scr[frame_pointer]
	match typeof(thing):
		TYPE_INT:
			_advance_at = now + thing
		TYPE_CALLABLE:
			thing.call()

	frame_pointer += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		end_credits.emit()

	_process_script()	
	if not in_sky:
		var vel = _get_velocity()
		_blacksmith.position += (delta * vel)
