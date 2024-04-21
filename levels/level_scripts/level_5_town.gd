extends Node3D

# Signals connected to the messages in the UI, the eldritch entity talking to the player
signal time_survived
signal time_not_survived

@onready var general_ambience_level_5 = $Audio/GeneralAmbienceLevel1
@onready var battle_ambience_level_5 = $Audio/BattleAmbienceLevel

@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

func _ready():
	general_ambience_level_5.play()
	
	await get_tree().create_timer(25).timeout
	level_timer.visible = true
	level_timer.start_timer()
	general_ambience_level_5.queue_free()
	battle_ambience_level_5.play()
	
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 300.0: # Survived ending
		time_survived.emit()
		
		Global.level_5_survived_passed_time = true
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
		
		player.kill()
		
	if player.dead == true: # Died ending
		time_not_survived.emit()
		Global.level_5_survived_passed_time = false
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
