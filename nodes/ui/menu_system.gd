extends Node2D


# indicates we should start the game:
#     (Enums.StartMode, level_path: String)
# if starting in StartMode.SINGLE_LEVEL the level_path is the resource path for
# that level.
#
# if starting in StartMode.NORMAL level is an empty string
signal start_game

signal quit_game

func _ready():
	Jukebox.play_title()

func _start_over():
	pass

func _start_exit():
	pass

func _is_click(event: InputEvent) -> bool:
	return event.is_class('InputEventMouseButton') and event.pressed

func _start_input(_viewport, event: InputEvent, _shape_idx):
	if _is_click(event):
		start_game.emit(Enums.StartMode.NORMAL, '')

func _quit_event(viewport, event, shape_idx):
	if _is_click(event):
		quit_game.emit()
