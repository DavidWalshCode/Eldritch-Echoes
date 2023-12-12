extends CharacterBody3D

@onready var camera_3d = $Camera3D # The $Camera3D is equivalent to get_node("Camera3D")
@onready var character_mover = $CharacterMover
@onready var health_manager = $HealthManager
@onready var weapon_manager = $Camera3D/WeaponManager

@export var mouse_sensitivity_h = 0.13 # Horizontal mouse sens
@export var mouse_sensitivity_v = 0.13 # Vertical mouse sens

const HOTKEYS = { # Hotkeys for weapon switching
	KEY_1: 0, # 1 for melee weapon
	KEY_2: 1, # 2 for machine gun
	KEY_3: 2, # 3 for shotgun
	KEY_4: 3, # 4 for rocket launcher
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

var dead = false
var times_died = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.died.connect(kill)

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

# Equivalent to update() in Unity, runs every frame
func _process(delta):
	if Input.is_action_just_pressed("quit"): # Currently 'Esc'
		get_tree().quit()
	if Input.is_action_just_pressed("restart"): # Currently 'r'
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"): # Currently 'f'
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if dead:
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") # Currently 'WASD'
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	if Input.is_action_just_pressed("jump"): # Currently 'Space'
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack")) # Attack

func kill():
	dead = true
	character_mover.set_move_dir(Vector3.ZERO) # Make sure the player can't move when they die

func hurt(damage_data : DamageData):
	health_manager.hurt(damage_data)
