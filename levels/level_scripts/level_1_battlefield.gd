extends Node3D

@onready var ambience_level_1 = $Audio/AmbienceLevel1
@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

func _ready():
	ambience_level_1.play()
	
	await get_tree().create_timer(5).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	await get_tree().create_timer(5).timeout
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 10.0: # Check if more than 2 minutes have passed
		Global.level_1_survived_passed_time = true
		
		# weapon_manager.unlock_weapon(2)
		
		# weapon_manager.switch_to_weapon_slot(2)
	
	if player.dead == true:
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
