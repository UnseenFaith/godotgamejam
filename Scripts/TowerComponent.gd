extends Area2D

var enemies: Array = []

signal fire

enum Targeting_Mode {
	CLOSEST,
	FARTHEST,
	HEALTHIEST,
	WEAKEST,
	FIRST,
	LAST
}

enum Turret_Type {
	Projectile,
	AOE
}

var tower_built: bool = false

@export var tower_range: int = 100
@export var speed: float = 1
@export var targeting_mode: Targeting_Mode = Targeting_Mode.FIRST
@export var turret_type: Turret_Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TowerRange.shape.radius = tower_range
	$ActivationTimer.wait_time = speed
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		enemies.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		enemies.erase(area)

func _on_activation_timer_timeout():
	if tower_built == true:
		emit_signal("fire")
