extends Node2D

@onready var tower = $TowerComponent

@export var duration: float = 5

func _on_tower_component_fire():
	for enemy in tower.enemies:
		if !enemy.slowed:
			enemy.emit_signal("on_slow", duration)
