extends Node3D

# Signals connected to the messages in the UI, the eldritch entity talking to the player
signal time_survived
signal time_not_survived

@onready var general_ambience_level_3 = $Audio/GeneralAmbienceLevel1
@onready var battle_ambience_level_3 = $Audio/BattleAmbienceLevel

@onready var portal_exit_sound = $Player/PortalManager/Audio/PortalExitSound

@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

var weapon_unlocked = false  # Flag to track weapon unlock status

func _ready():
	portal_exit_sound.play()
	general_ambience_level_3.play()
	
	await get_tree().create_timer(5).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	battle_ambience_level_3.play()
	await get_tree().create_timer(4).timeout
	general_ambience_level_3.queue_free()
	
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 10.0 and not weapon_unlocked:
		time_survived.emit()
		
		weapon_unlocked = true
		Global.level_3_survived_passed_time = true
		
		weapon_manager.check_weapon_unlocks()
	
	if player.dead:
		time_not_survived.emit()
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
