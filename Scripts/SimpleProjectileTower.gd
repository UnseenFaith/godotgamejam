extends Node2D

@onready var tower = $TowerComponent
@export var projectile: PackedScene
@export var projectile_speed: int = 200


func _on_tower_component_fire() -> void:
	if tower.enemies.size() <= 0:
		return
	var target = tower.enemies[0];
	var target_location = target.global_transform.origin
	rotation = atan2(target_location.y - global_position.y, target_location.x - global_position.x)
	var shot = projectile.instantiate()
	shot.speed = projectile_speed
	shot.set_target(target)
	shot.position = $ProjectileLocation.get_global_transform().origin
	get_parent().add_child(shot)
