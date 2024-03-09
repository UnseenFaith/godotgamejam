extends Area2D

var enemies: Array = []

enum Targeting_Mode {
	CLOSEST,
	FARTHEST,
	HEALTHIEST,
	WEAKEST,
	FIRST,
	LAST
}

@export var range: int = 100
@export var shooting_interval: int = 3
@export var projectile_speed: int = 200
@export var targeting_mode: Targeting_Mode = Targeting_Mode.FIRST
@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = range;
	$ShootTimer.wait_time = shooting_interval



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		enemies.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		enemies.erase(area)

func _on_timer_timeout() -> void:
	if enemies.size() <= 0:
		return
	var target = enemies[0];
	var shot = projectile.instantiate()
	shot.speed = projectile_speed
	shot.set_target(target)
	shot.position = $ProjectileLocation.get_global_transform().origin
	get_parent().add_child(shot)
