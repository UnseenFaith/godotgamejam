extends Area2D

var target: Area2D;
@export var speed: int = 200
@export var damage: int = 1
var velocity

# Called when the node enters the scene tree for the first time.
func set_target(new_target: Area2D) -> void:
	target = new_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		velocity = ((target.get_global_transform().origin - position).normalized() * speed)
		position += velocity * delta
		rotation = velocity.angle()
	else:
		queue_free()

