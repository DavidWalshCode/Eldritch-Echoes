extends Node3D

@onready var ambience_level_5 = $Audio/AmbienceLevel5
@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

func _ready():
	ambience_level_5.play()
	
	await get_tree().create_timer(20).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	await get_tree().create_timer(2).timeout
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 300.0: # Check if more than 5 minutes have passed
		Global.level_5_survived_passed_time = true
	
	if player.dead == true:
		Global.level_5_survived_passed_time = false
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
