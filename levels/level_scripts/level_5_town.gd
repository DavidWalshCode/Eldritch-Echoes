extends Node3D

@onready var ambience_level_5 = $Audio/AmbienceLevel5
@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager

func _ready():
	ambience_level_5.play()
	
	await get_tree().create_timer(10).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	await get_tree().create_timer(3).timeout
	enemy_spawner_manager.start_spawning()

func _process(delta):
	if level_timer.get_time() > 60.0: # Check if more than a minute has passed
		print("More than a minute has passed.")

	if level_timer.get_time() > 120.0: # Check if more than 2 minutes have passed
		print("More than 2 minutes have passed.")
	
	if level_timer.get_time() > 180.0: # Check if more than 2 minutes have passed
		print("More than 3 minutes have passed.")
		Global.level_1_survived_passed_time = true
	
	if player.dead == true:
		level_timer.stop_timer()
		enemy_spawner_manager.stop_spawning()
		print("player dead")
