extends Node

signal health_depleted

@export var health: int = 1

func take_damage(damage: int):
	health -= damage
	emit_signal("health_depleted")
