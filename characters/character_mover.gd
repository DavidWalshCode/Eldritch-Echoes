extends Node3D

@export var jump_force = 15.0
@export var gravity = 30.0

@export var max_speed = 20.0
@export var move_accel = 5.0
@export var stop_drag = 0.11
@export var air_drag = 0.19

var character_body : CharacterBody3D
var move_drag = 0.0
var move_dir : Vector3
var double_jump_available = true

@onready var jump_sounds = $Audio/JumpSounds.get_children()
@onready var footstep_sounds = $Audio/FootstepSounds.get_children()
@export var footstep_sound_interval = 0.3  # Time in seconds between footstep sounds
var last_footstep_time = -9999.0  # Last time a footstep sound was played

func _ready():
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed

func set_move_dir(new_move_dir : Vector3):
	move_dir = new_move_dir

func jump():
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force
		double_jump_available = true
		play_jump_sound()
	elif double_jump_available: 
		double_jump_available = false
		character_body.velocity.y = jump_force
		play_jump_sound()

# Runs 60 times a sec, fixedupdate in Unity
func _physics_process(delta):
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0.0
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
	
	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag
	if not character_body.is_on_floor(): # Use air_drag if the character is not on the floor
		drag = air_drag
	
	var flat_velo = character_body.velocity
	flat_velo.y = 0.0
	character_body.velocity += move_accel * move_dir - flat_velo * drag

	character_body.move_and_slide()

	# Footstep sound logic
	if character_body.is_on_floor() and not move_dir.is_zero_approx():
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_footstep_time > footstep_sound_interval:
			last_footstep_time = current_time
			play_footstep_sound()

func play_footstep_sound():
	footstep_sounds[randi() % footstep_sounds.size()].play() # Randomly play a footstep sound

func play_jump_sound():
	jump_sounds[randi() % jump_sounds.size()].play() # Randomly play a jump sound
