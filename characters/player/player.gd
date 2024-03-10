extends CharacterBody3D

@export var mouse_sensitivity_h = 0.13 # Horizontal mouse sens
@export var mouse_sensitivity_v = 0.13 # Vertical mouse sens
@export var max_camera_lean = 1.5  # Maximum lean angle in degrees
@export var camera_lean_speed = 10.0  # Speed at which the camera leans

var current_camera_lean = 0.0  # Current lean angle

@onready var camera_3d = $Camera3D # The $Camera3D is equivalent to get_node("Camera3D")
@onready var character_mover = $CharacterMover
@onready var health_manager = $HealthManager
@onready var weapon_manager = $Camera3D/WeaponManager

const HOTKEYS = { # Hotkeys for weapon switching
	KEY_1: 0, # 1 for sword
	KEY_2: 1, # 2 for revolvers
	KEY_3: 2, # 3 for machine gun
	KEY_4: 3, # 4 for shotgun
	KEY_5: 4, # 5 for rocket launcher
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

var dead = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.died.connect(kill)
	
	Global.debug.add_property("Death Count", Global.death_count, 1) # Adding death count to debug panel

func _input(event):
	if dead:
		return

	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h # Horizontal mouse look
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v # Vertical mouse look
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90) # Clamps mouse look to not be able to slip
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: # Mouse scroll up for previous weapon
			weapon_manager.switch_to_previous_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: # Mouse scroll down for next weapon
			weapon_manager.switch_to_next_weapon()
	
	if event is InputEventKey and event.pressed and event.keycode in HOTKEYS: # Use numbers (hotkeys) for weapon switching
		weapon_manager.switch_to_weapon_slot(HOTKEYS[event.keycode])
		
	if event.is_action_pressed("crouch"): # Currently 'Ctrl'
		character_mover.start_crouching()
	elif event.is_action_released("crouch"):
		character_mover.stop_crouching()

# Equivalent to update() in Unity, runs every frame
func _process(delta):
	if Input.is_action_just_pressed("quit"): # Currently 'Esc'
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"): # Currently 'r'
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("kill_player"): # Currently 'k'
		kill()
	
	if Input.is_action_just_pressed("fullscreen"): # Currently 'f'
		var fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if dead:
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") # Currently 'WASD'
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_mover.set_move_dir(move_dir)
	update_camera_lean(delta) # Update camera lean
	
	if Input.is_action_just_pressed("jump"): # Currently 'Space'
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack")) # Attack, currently 'Mouse 1'

func hurt(damage_data : DamageData):
	health_manager.hurt(damage_data)

func kill():
	#dead = true
	#character_mover.set_move_dir(Vector3.ZERO) # Make sure the player can't move when they die
	
	Global.death_count += 1  # Increment death count
	load_next_level_based_on_death_count()

func load_next_level_based_on_death_count():
	# Switch case for loading a level based on the player death count
	match Global.death_count: 
		1:
			load_next_level() # Load level 2, death count is 1
		2:
			load_next_level() # Load level 3, death count is 2
		3:
			load_next_level() # Load level 4, death count is 3
		4:
			load_next_level() # load Level 5, death count is 4
		_:
			get_tree().quit() # get_tree().change_scene("res://Game_Over.tscn") # Default case

func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	var next_level_path = "res://levels/town/level_" + str(next_level_number) + "_town.tscn" # Could also have const FILE_BEGIN = "res://levels/level_"
	get_tree().change_scene_to_file(next_level_path)

func update_camera_lean(delta):
	var input_direction = 0.0

	if Input.is_action_pressed("move_right"):
		input_direction = -1.0
	elif Input.is_action_pressed("move_left"):
		input_direction = 1.0

	# Update current camera lean based on input direction
	if input_direction != 0.0:
		current_camera_lean += delta * camera_lean_speed * input_direction
	else:
		current_camera_lean = lerp(current_camera_lean, 0.0, delta * camera_lean_speed) # Gradually return the camera to the center if no input is detected

	# Clamp the current camera lean to the maximum values
	current_camera_lean = clamp(current_camera_lean, -max_camera_lean, max_camera_lean)

	# Apply the lean to the camera's rotation
	camera_3d.rotation_degrees.z = current_camera_lean
