extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE

@onready var enemy_animation_player = $Graphics/AnimationPlayer
@onready var enemy_health_manager = $EnemyHealthManager

var player = null
@export var sight_angle = 45.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.connect("hurt_signal", Callable(self, "hurt"))
				
	enemy_health_manager.connect("died", Callable(self, "set_state_dead"))
	
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
	enemy_animation_player.play("walk")
	
func set_state_attack():
	current_state = STATES.ATTACK
	enemy_animation_player.play("attack")
	
func set_state_dead():
	current_state = STATES.DEAD
	enemy_animation_player.play("die")

func process_state_idle(delta):
	pass

func process_state_chase(delta):
	pass

func process_state_attack(delta):
	pass

func process_state_dead(delta):
	pass

func hurt(damage_data : DamageData):
	enemy_health_manager.hurt(damage_data)

func can_see_player():
	var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.basis.z
	return rad_to_deg(forwards.angle_to(direction_to_player)) < sight_angle and has_line_of_sight_player()

func has_line_of_sight_player():
	var enemy_position = global_transform.origin + Vector3.UP
	var player_position = player.global_transform.origin + Vector3.UP
	
	var space_state = get_world_3d().direct_space_state
	var query_params = PhysicsRayQueryParameters3D.new()  # Assuming correct use for 3D context
	query_params.from = enemy_position
	query_params.to = player_position
	query_params.collision_mask = 1
	query_params.exclude = []  # Make sure to se,t any needed parameters
	# Assume other necessary parameters are set here

	var result = space_state.intersect_ray(query_params)
	
	# Check if the result dictionary is empty
	if result.size() == 0:  # or simply if not result:
		return true  # No collision means clear line of sight
	return false  # Collision detected
