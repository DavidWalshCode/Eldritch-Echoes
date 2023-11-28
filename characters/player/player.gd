extends CharacterBody3D

@onready var camera_3d = $Camera3D # The $Camera3D is equivalent to get_node("Camera3D")
@onready var character_mover = $CharacterMover

@export var mouse_sensitivity_h = 0.13 # Horizontal mouse sens
@export var mouse_sensitivity_v = 0.13 # Vertical mouse sens

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h # Horizontal mouse look
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v # Vertical mouse look
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90) # Clamps mouse look to not be able to slip

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
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") # Currently 'WASD'
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	if Input.is_action_just_pressed("jump"): # Currently 'Space'
		character_mover.jump()
