extends CharacterBody3D

signal enemy_attack

enum STATES {IDLE, CHASE, ATTACK, DEAD}

@export var sight_angle = 45.0
@export var turn_speed = 360.0 # Converted from degrees to radians when used
@export var attack_range = 2.0
@export var attack_rate = 0.5
@export var attack_animation_speed_mod = 0.7

var current_state = STATES.IDLE
var player = null
var path = []

var attack_timer : Timer
var can_attack = true

@onready var enemy_animation_player = $Graphics/AnimationPlayer
@onready var enemy_health_manager = $EnemyHealthManager
@onready var enemy_character_mover = $EnemyCharacterMover
@onready var navigation_agent = $NavigationAgent3D
@onready var enemy_aimer = $EnemyAimer

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", Callable(self, "finish_attack"))
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	player = get_tree().get_nodes_in_group("player")[0]
	
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.connect("hurt_signal", Callable(self, "hurt"))
				
	enemy_health_manager.connect("enemy_died", Callable(self, "set_state_dead"))
	
	set_state_idle()
	
func _process(delta):
	#print(can_see_player())
	match current_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	current_state = STATES.IDLE
	#enemy_animation_player.get_animation("idle").loop = true
	enemy_animation_player.play("idle")
	
func set_state_chase():
	current_state = STATES.CHASE
	#enemy_animation_player.get_animation("walk").loop = true
	enemy_animation_player.play("walk", 0.2)
	print("alerted")
	
func set_state_attack():
	current_state = STATES.ATTACK
	
func set_state_dead():
	current_state = STATES.DEAD
	enemy_animation_player.play("die")
	enemy_character_mover.freeze()
	$CollisionShape3D.disabled = true

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	if within_distance_of_player(attack_range) and has_line_of_sight_player():
		set_state_attack()
	
	var player_position = player.global_transform.origin
	var enemy_position = global_transform.origin
	
	velocity = Vector3.ZERO
	navigation_agent.set_target_position(player_position)
	var next_navigation_point = navigation_agent.get_next_path_position()
	velocity = (next_navigation_point - enemy_position).normalized() * enemy_character_mover.max_speed
	
	face_direction(velocity, delta)
	enemy_character_mover.set_move_direction(velocity)

func process_state_attack(delta):
	enemy_character_mover.set_move_direction(Vector3.ZERO) # Currently dont want to move while attack
	
	# face_direction(global_transform.origin.direction_to(player.global_transform.origin), delta)
	
	if can_attack:
		
		if !within_distance_of_player(attack_range) or !can_see_player():
			set_state_chase()
		else:
			start_attack()

func process_state_dead(delta):
	pass

func hurt(damage_data : DamageData):
	if current_state == STATES.IDLE:
		set_state_chase()
	enemy_health_manager.hurt(damage_data) # Change to player health manager?

func start_attack():
	can_attack = false
	enemy_animation_player.play("attack", -1, attack_animation_speed_mod)
	attack_timer.start()
	enemy_aimer.aim_at_position(player.global_transform.origin + Vector3.UP)

func emit_attack():
	enemy_attack.emit()

func finish_attack():
	can_attack = true

func can_see_player():
	var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.basis.z
	return rad_to_deg(forwards.angle_to(direction_to_player)) < sight_angle and has_line_of_sight_player()

func has_line_of_sight_player():
	var enemy_position = global_transform.origin + Vector3.UP
	var player_position = player.global_transform.origin + Vector3.UP
	
	var space_state = get_world_3d().direct_space_state
	var query_params = PhysicsRayQueryParameters3D.new()
	query_params.from = enemy_position
	query_params.to = player_position
	query_params.collision_mask = 1
	query_params.exclude = []  # Make sure to set any needed parameters

	var result = space_state.intersect_ray(query_params)
	
	# Check if the result dictionary is empty
	if result.size() == 0:  # or simply if not result:
		return true  # No collision means clear line of sight
	return false  # Collision detected

func face_direction(direction : Vector3, delta):
	var angle_diff = global_transform.basis.z.angle_to(direction)
	var turn_right = sign(global_transform.basis.x.dot(direction)) # The dot product with the direction we want to take and the vector pointing to the right of this character. If that vector is pointing right and the direction we are facing is also right, it returns a positive number. If left it returns a negative number
	
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		rotation.y = atan2(direction.x, direction.z)
	else:
		rotation.y += deg_to_rad(turn_speed) * delta * turn_right

func alert(check_line_of_sight = true):
	if current_state != STATES.IDLE:
		return
	if check_line_of_sight and !has_line_of_sight_player():
		return
	set_state_chase()

func within_distance_of_player(distance : float):
	return global_transform.origin.distance_to(player.global_transform.origin) < attack_range
