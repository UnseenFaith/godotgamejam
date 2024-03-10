extends Area2D

var start_location: Marker2D
var end_location: Marker2D

signal on_slow(duration: float)

@export var speed: int = 100
@onready var health_component = $HealthComponent

var slowed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = start_location.global_position
	set_physics_process(false)
	call_deferred('setup')

func setup() -> void:
	await get_tree().physics_frame
	set_physics_process(true)
	$NavigationAgent2D.target_position = end_location.global_position
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if $NavigationAgent2D.is_navigation_finished():
		call_deferred("queue_free")
		return
		
	var next_location = $NavigationAgent2D.get_next_path_position()
	var direction = global_position.direction_to(next_location)
	if slowed:
		velocity = (direction * speed) * .25
	else:
		velocity = direction * speed
	position += velocity * delta


func _on_area_entered(area):
	if area.is_in_group("projectile"):
		health_component.take_damage(area.damage)
		area.queue_free()

func _on_health_component_health_depleted():
	if health_component.health <= 0:
		queue_free()



func _on_slow(duration):
	$SlowTimer.wait_time = duration
	slowed = true
	$SlowTimer.start()


func _on_slow_timer_timeout():
	$SlowTimer.stop()
	slowed = false

