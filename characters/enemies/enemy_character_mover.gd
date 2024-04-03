extends Node3D

@export_category("Movement") # @export_group("")
@export var jump_force = 14.0
@export var gravity = 30.0
@export var max_speed = 20.0
@export var move_accel = 5.0
@export var stop_drag = 0.11
@export var air_drag = 0.19

var character_body : CharacterBody3D
var move_drag = 0.0
var move_direction : Vector3
var current_speed
var double_jump_available = true

var frozen = false

func _ready():
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed

func set_move_direction(new_move_direction : Vector3):
	move_direction = new_move_direction.normalized() # Might not need .normalized()

func jump():
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force
		double_jump_available = true
	elif double_jump_available: 
		character_body.velocity.y = jump_force
		double_jump_available = false

# Runs 60 times a sec, fixedupdate in Unity
func _physics_process(delta):
	if frozen:
		return
	
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0.0
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
	
	var drag = move_drag
	if move_direction.is_zero_approx():
		drag = stop_drag
	if not character_body.is_on_floor(): # Use air_drag if the character is not on the floor
		drag = air_drag
	
	var flat_velo = character_body.velocity
	flat_velo.y = 0.0

	character_body.velocity += move_accel * move_direction - flat_velo * drag

	character_body.move_and_slide()

func freeze():
	frozen = true

func unfreeze():
	frozen = false
