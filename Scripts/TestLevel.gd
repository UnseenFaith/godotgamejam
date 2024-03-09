extends Node2D

@export var enemy: PackedScene
@export var start_location: Marker2D
@export var end_location: Marker2D


func _on_wave_spawner_timeout():
	var new_enemy = enemy.instantiate()
	new_enemy.start_location = start_location
	new_enemy.end_location = end_location
	
	add_child(new_enemy)
