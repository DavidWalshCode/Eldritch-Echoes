extends Node3D

# Signals connected to the messages in the UI, the eldritch entity talking to the player
signal time_survived
signal time_not_survived

@onready var ambience_level_2 = $Audio/AmbienceLevel2
@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

var weapon_unlocked = false  # Flag to track weapon unlock status

func _ready():
	ambience_level_2.play()
	
	await get_tree().create_timer(5).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	await get_tree().create_timer(3).timeout
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 10.0 and not weapon_unlocked:
		time_survived.emit()
		
		weapon_unlocked = true
		Global.level_2_survived_passed_time = true
		
		weapon_manager.check_weapon_unlocks()
	
	if player.dead:
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
		time_not_survived.emit()
