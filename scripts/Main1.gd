extends Node2D

@export var level_items = [
	'bronze_shield',
	'gold_shield',
	'diamond_shield'
]

# Called when the node enters the scene tree for the first time.
func start_level():
	$Hud.visible = true
	$Hud.start_level(level_items)

func end_level():
	$Level.end_level()