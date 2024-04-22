extends CharacterBody3D

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

@export var mouse_sensitivity_h = 0.13 # Horizontal mouse sens
@export var mouse_sensitivity_v = 0.13 # Vertical mouse sens
@export var max_camera_lean = 1.5 # Maximum lean angle in degrees
@export var camera_lean_speed = 10.0 # Speed at which the camera leans

var current_camera_lean = 0.0 # Current lean angle
var dead = false

@onready var camera_3d = $Camera3D # The $Camera3D is equivalent to get_node("Camera3D")
@onready var character_mover = $CharacterMover
@onready var health_manager = $HealthManager
@onready var item_pickup_manager = $ItemPickupManager
@onready var weapon_manager = $Camera3D/WeaponManager

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	item_pickup_manager.max_player_health = health_manager.max_health
	health_manager.connect("health_changed", Callable(item_pickup_manager, "update_player_health"))
	item_pickup_manager.connect("got_item_pickup", Callable(weapon_manager, "get_item_pickup"))
	item_pickup_manager.connect("got_item_pickup", Callable(health_manager, "get_item_pickup"))
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
	if Input.is_action_just_pressed("settings_menu"): # Currently 'Esc'
		Global.open_settings_menu()
	
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
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") # Currently 'WASD'
	var move_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	character_mover.set_move_direction(move_direction)
	update_camera_lean(delta) # Update camera lean
	
	if Input.is_action_just_pressed("jump"): # Currently 'Space'
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack")) # Attack, currently 'Mouse 1'

func hurt(damage_data : DamageData):
	health_manager.hurt(damage_data)

func kill():
	dead = true
	character_mover.set_move_direction(Vector3.ZERO) # Make sure the player can't move when they die
	
	Global.death_count += 1  # Increment death count
	
	await get_tree().create_timer(4).timeout
	get_tree().call_group("instanced", "queue_free") # For changing scenes, this deletes all of the things in the instanced group (enemies and projectiles) in between scenes
	
	await get_tree().create_timer(4).timeout
	load_next_level_based_on_death_count()

func load_next_level_based_on_death_count():
	# Switch case for loading the town level based on the player death count
	match Global.death_count: 
		1:
			# Load town level 2, death count is 1
			$"..".queue_free() # Removing the Level1Battlefield node
			SceneManager.swap_scenes(SceneRegistry.levels["level_2_town"], get_tree().root, self, "fade_to_white")
		2:
			# Load town level 3, death count is 2
			$"..".queue_free() # Removing the Level2Battlefield node
			SceneManager.swap_scenes(SceneRegistry.levels["level_3_town"], get_tree().root, self, "fade_to_white")
		3:
			# Load town level 4, death count is 3
			$"..".queue_free() # Removing the Level3Battlefield node
			SceneManager.swap_scenes(SceneRegistry.levels["level_4_town"], get_tree().root, self, "fade_to_white")
		4:
			# Load town level 5, death count is 4
			$"..".queue_free() # Removing the Level4Battlefield node
			SceneManager.swap_scenes(SceneRegistry.levels["level_5_town"], get_tree().root, self, "fade_to_white")
		_:
			# Default case (5 deaths), game ending
			await get_tree().create_timer(2).timeout
			$"..".queue_free() # Removing the Level5Town node
			
			SceneManager.swap_scenes(SceneRegistry.main_scenes["game_ending"], get_tree().root, self, "fade_to_black")

func load_level_through_portal(level_number : int):
	if level_number == 1:
		$"..".queue_free() # Removing the Level1Town node
		SceneManager.swap_scenes(SceneRegistry.levels["level_1_battlefield"], get_tree().root, self, "fade_to_black")
	
	elif level_number == 2:
		$"..".queue_free() # Removing the Level2Town node
		SceneManager.swap_scenes(SceneRegistry.levels["level_2_battlefield"], get_tree().root, self, "fade_to_black")

	elif level_number == 3:
		$"..".queue_free() # Removing the Level3Town node
		SceneManager.swap_scenes(SceneRegistry.levels["level_3_battlefield"], get_tree().root, self, "fade_to_black")

	elif level_number == 4:
		$"..".queue_free() # Removing the Level4Town node
		SceneManager.swap_scenes(SceneRegistry.levels["level_4_battlefield"], get_tree().root, self, "fade_to_black")

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


