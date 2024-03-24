extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE

@onready var enemy_animation_player = $Graphics/AnimationPlayer
@onready var enemy_health_manager = $EnemyHealthManager

func _ready():
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.connect("hurt_signal", Callable(self, "hurt"))
				
	enemy_health_manager.connect("died", Callable(self, "set_state_dead"))
	
	set_state_idle()
	
func _process(delta):
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
