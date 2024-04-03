extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE

@onready var enemy_animation_player = $Graphics/AnimationPlayer
@onready var enemy_health_manager = $EnemyHealthManager
@onready var enemy_character_mover = $EnemyCharacterMover

@onready var navigation_agent = $NavigationAgent3D

var player = null
var path = []

@export var sight_angle = 45.0
@export var turn_speed = 360.0 # Converted from degrees to radians when used

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.connect("hurt_signal", Callable(self, "hurt"))
				
	enemy_health_manager.connect("enemy_died", Callable(self, "set_state_dead"))
	
	#enemy_character_mover.init(self) # might not need
	
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
	enemy_animation_player.get_animation("idle").loop = true
	enemy_animation_player.play("idle")
	
func set_state_chase():
	current_state = STATES.CHASE
	enemy_animation_player.get_animation("walk").loop = true
	enemy_animation_player.play("walk", 0.2)
	print("alerted")
	
func set_state_attack():
	current_state = STATES.ATTACK
	enemy_animation_player.play("attack")
	
func set_state_dead():
	current_state = STATES.DEAD
	enemy_animation_player.play("die")
	enemy_character_mover.freeze()
	$CollisionShape3D.disabled = true

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	var player_position = player.global_transform.origin
	var enemy_position = global_transform.origin
	
	'''
	path = navigation_region_3d.get_simple_path(enemy_position, player_position)
	var goal_position = player_position
	
	if path.size() > 1:
		goal_position = path[1]
	
	var direction = goal_position - enemy_position
	direction.y = 0
	enemy_character_mover.set_move_direction(direction)
	'''
	
	navigation_agent.set_target_position(player.position)
	var next_navigation_point = navigation_agent.get_next_path_position()
	
	var direction = next_navigation_point - enemy_position.normalized()
	#direction.y = 0
	
	enemy_character_mover.set_move_direction(direction)
	face_direction(direction, delta)
	
	#### - GPT
	var max_speed = 10
	var target_position = player.global_transform.origin
	navigation_agent.set_target_location(target_position)
	
	var velocity = Vector3.ZERO
	if navigation_agent.is_navigation_finished():
		pass# If close enough or navigation finished, you might want to switch to ATTACK state or stop moving.
	else:
		var next_point = navigation_agent.get_next_location()
		var direction_d = (next_point - global_transform.origin).normalized()
		velocity = direction_d * max_speed
		face_direction(direction_d, delta)  # Ensure facing towards the movement direction
		
	# Apply the velocity, considering Y-axis separately if needed for gravity/jumping
	#character_body.velocity.x = velocity.x
	#character_body.velocity.z = velocity.z
	#character_body.move_and_slide()
	enemy_character_mover.velocity.x = velocity.x
	enemy_character_mover.velocity.z = velocity.z
	enemy_character_mover.move_and_slide()
	

func process_state_attack(delta):
	pass

func process_state_dead(delta):
	pass

func hurt(damage_data : DamageData):
	if current_state == STATES.IDLE:
		set_state_chase()
	enemy_health_manager.hurt(damage_data)

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
