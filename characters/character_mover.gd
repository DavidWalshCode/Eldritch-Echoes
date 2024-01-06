extends Node3D

@export var jump_force = 17.0
@export var gravity = 30.0

@export var max_speed = 20.0
@export var move_accel = 5.0
@export var stop_drag = 0.9

var character_body : CharacterBody3D
var move_drag = 0.0
var move_dir : Vector3
var double_jump_available = true

func _ready():
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed

func set_move_dir(new_move_dir : Vector3):
	move_dir = new_move_dir

func jump():
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force
		double_jump_available = true
	elif double_jump_available: 
		double_jump_available = false
		character_body.velocity.y = jump_force

# Runs 60 times a sec, fixedupdate in Unity
func _physics_process(delta):
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0.0
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
	
	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag
	
	var flat_velo = character_body.velocity
	flat_velo.y = 0.0
	character_body.velocity += move_accel * move_dir - flat_velo * drag
	
	character_body.move_and_slide()
	
