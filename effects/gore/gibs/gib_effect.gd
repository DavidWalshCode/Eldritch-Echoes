extends CharacterBody3D

@export var start_move_speed = 30
@export var gravity = 35.0
@export var drag = 0.01
@export var velocity_retained_on_bounce = 0.8
@export var stationary_threshold = 0.05  # Threshold below which the gib is considered stationary

func _ready():
	velocity = -global_transform.basis.y * start_move_speed

func _physics_process(delta):
	velocity += -velocity * drag + Vector3.DOWN * gravity * delta
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var d = velocity
		var n = collision.get_normal()
		var r = d - 2 * d.dot(n) * n # Equation calculates the reflection (equation for reflected vector: r = d - 2(d . n) * n)
		velocity = r * velocity_retained_on_bounce

	# Check if the velocity magnitude is below the threshold and the gib is not moving
	if velocity.length() < stationary_threshold:
		queue_free() # Assume the gib is stationary and delete the collision shape
