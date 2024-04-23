extends Node3D

# Signals connected to the messages in the UI, the eldritch entity talking to the player
signal level_5_time_survived
signal level_5_time_not_survived

@onready var general_ambience_level_5 = $Audio/GeneralAmbienceLevel5
@onready var horror_ambience_level_5 = $Audio/HorrorAmbienceLevel5
@onready var rain_ambience_level_5 = $Audio/RainAmbienceLevel5
@onready var battle_ambience_level_5 = $Audio/BattleAmbienceLevel5
@onready var intro_sting_level_5 = $Audio/IntroStingLevel5

@onready var postive_message_reaction_sound = $Audio/PostiveMessageReactionSound
@onready var negative_message_reaction_sound = $Audio/NegativeMessageReactionSound

@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

func _ready():
	intro_sting_level_5.play()
	rain_ambience_level_5.play()
	general_ambience_level_5.play()
	horror_ambience_level_5.play()
	
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = false
	Global.is_level_3 = false
	Global.is_level_4 = false
	Global.is_level_5 = true
	
	await get_tree().create_timer(25).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	battle_ambience_level_5.play()
	
	await get_tree().create_timer(2).timeout
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 300.0: # Survived ending
		level_5_time_survived.emit()
		postive_message_reaction_sound.play()
		
		Global.level_5_survived_passed_time = true
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
		
		player.kill()
		
	if player.dead == true: # Died ending
		level_5_time_not_survived.emit()
		negative_message_reaction_sound.play()
		Global.level_5_survived_passed_time = false
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
