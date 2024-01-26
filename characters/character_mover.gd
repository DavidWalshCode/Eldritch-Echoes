extends Node3D

@export var jump_force = 14.0
@export var gravity = 30.0

@export var max_speed = 20.0
@export var move_accel = 5.0
@export var stop_drag = 0.11
@export var air_drag = 0.19

var character_body : CharacterBody3D
var move_drag = 0.0
var move_dir : Vector3
var current_speed
var double_jump_available = true
var is_crouching : bool = false

signal moved(velocity : Vector3, grounded : bool)

@onready var jump_sounds = $Audio/JumpSounds.get_children()
@onready var footstep_sounds = $Audio/FootstepSounds.get_children()
@export var footstep_sound_interval = 0.3  # Time in seconds between footstep sounds
var last_footstep_time = -9999.0  # Last time a footstep sound was played

@onready var player_animations = $"../PlayerAnimations"
@export_range(5, 10, 0.1) var crouch_speed = 0.7
@onready var crouch_shape_cast = $"../CrouchShapeCast"
@export var crouch_movement_speed_modifier = 0.6  # % of normal speed when crouching

@export var min_slide_speed = 10.0  # Minimum speed to start sliding
@export var slide_speed_modifier = 1.5  # Speed modifier during sliding
var is_sliding : bool = false
var slide_timer : Timer
@onready var sliding_sound = $Audio/SlidingSounds/SlidingSound1

# Pitch variation range
@export var min_pitch_scale = 0.9
@export var max_pitch_scale = 1.1

@onready var slide_effect = $"../SlideEffect"

func _ready():
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed
	
	crouch_shape_cast.add_exception($"..") # Add crouch check collision shapecast exception for Player node
	
	# Create a Timer node for sliding
	slide_timer = Timer.new()
	slide_timer.wait_time = 0.7  # Set the duration of sliding
	slide_timer.one_shot = true  # Timer stops after firing once
	add_child(slide_timer)
	slide_timer.connect("timeout", Callable(self, "_on_slide_timer_timeout"))

func set_move_dir(new_move_dir : Vector3):
	move_dir = new_move_dir

func jump():
	if is_crouching == false: # Can only jump if you are not crouching
		if character_body.is_on_floor():
			character_body.velocity.y = jump_force
			double_jump_available = true
			play_jump_sound()
		elif double_jump_available: 
			double_jump_available = false
			character_body.velocity.y = jump_force
			play_jump_sound()

func start_crouching():
	if !is_crouching and crouch_shape_cast.is_colliding() == false:
		if current_speed > min_slide_speed:
			is_sliding = true
			slide_timer.start()  # Start the sliding timer
			play_sliding_sound()  # Play a sliding sound
			slide_effect.emitting = true
		else:
			is_sliding = false
			slide_effect.emitting = false
		crouching(true)

func stop_crouching():
	if is_crouching:
		is_sliding = false  # Stop sliding when uncrouching
		slide_timer.stop()  # Stop the timer if it's running
		stop_sliding_sounds()
		slide_effect.emitting = false
		crouching(false)

func crouching(state : bool):
	match state:
		true:
			player_animations.play("crouch", 0, crouch_speed)
		false:
			player_animations.play("crouch", 0, -crouch_speed, true)

func _on_animation_player_animation_started(anim_name):
	if anim_name == "crouch":
		is_crouching = !is_crouching

func _on_slide_timer_timeout():
	is_sliding = false  # Stop sliding
	stop_sliding_sounds()
	slide_effect.emitting = false

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
	
	# Adjust move_accel based on crouching state
	var adjusted_move_accel = move_accel
	if is_crouching and character_body.is_on_floor():
		if is_sliding:
			adjusted_move_accel *= slide_speed_modifier
		else:
			adjusted_move_accel *= crouch_movement_speed_modifier

	character_body.velocity += adjusted_move_accel * move_dir - flat_velo * drag
	#character_body.velocity += move_accel * move_dir - flat_velo * drag

	character_body.move_and_slide()
	moved.emit(character_body.velocity, character_body.is_on_floor())
	
	current_speed = character_body.velocity.length()
	Global.debug.add_property("Movement Speed", current_speed, 1) # Adding movement speed to debug panel

	# Footstep sound logic
	if character_body.is_on_floor() and not move_dir.is_zero_approx():
		var current_time = Time.get_ticks_msec() / 1000.0
		footstep_sound_interval = 0.3
		if is_crouching:
			footstep_sound_interval = 0.5
		if current_time - last_footstep_time > footstep_sound_interval:
			last_footstep_time = current_time
			play_footstep_sound()

func play_footstep_sound():
	footstep_sounds[randi() % footstep_sounds.size()].play() # Randomly play a footstep sound

func play_jump_sound():
	jump_sounds[randi() % jump_sounds.size()].play() # Randomly play a jump sound

func play_sliding_sound():
	if character_body.is_on_floor(): # Only play the sliding sound if the player is on the ground
		# Randomize pitch scale
		var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
		sliding_sound.pitch_scale = random_pitch
		sliding_sound.play()

func stop_sliding_sounds():
	if sliding_sound.playing:
		sliding_sound.stop()
