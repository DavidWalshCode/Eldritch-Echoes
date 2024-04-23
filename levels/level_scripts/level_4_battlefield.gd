extends Node3D

# Signals connected to the messages in the UI, the eldritch entity talking to the player
signal level_4_time_survived
signal level_4_time_not_survived

@onready var general_ambience_level_4 = $Audio/GeneralAmbienceLevel4
@onready var battle_ambience_level_4 = $Audio/BattleAmbienceLevel4
@onready var rain_ambience_level_4 = $Audio/RainAmbienceLevel4

@onready var portal_exit_sound = $Player/PortalManager/Audio/PortalExitSound

@onready var postive_message_reaction_sound = $Audio/PostiveMessageReactionSound
@onready var negative_message_reaction_sound = $Audio/NegativeMessageReactionSound

@onready var level_timer = $Player/UserInterface/TimerContainer/LevelTimer
@onready var player = $Player
@onready var enemy_spawner_manager = $Enemies/EnemySpawnerManager
@onready var weapon_manager = $Player/Camera3D/WeaponManager

var weapon_unlocked = false  # Flag to track weapon unlock status

func _ready():
	portal_exit_sound.play()
	rain_ambience_level_4.play()
	general_ambience_level_4.play()
	
	await get_tree().create_timer(3).timeout
	level_timer.visible = true
	level_timer.start_timer()
	
	battle_ambience_level_4.play()
	
	await get_tree().create_timer(2).timeout
	enemy_spawner_manager.manager_start_spawning()

func _process(delta):
	if level_timer.get_time() > 210.0 and not weapon_unlocked:
		level_4_time_survived.emit()
		postive_message_reaction_sound.play()
		
		weapon_unlocked = true
		Global.level_4_survived_passed_time = true
		
		weapon_manager.check_weapon_unlocks()
	
	if player.dead:
		level_4_time_not_survived.emit()
		negative_message_reaction_sound.play()
		level_timer.stop_timer()
		enemy_spawner_manager.manager_stop_spawning()
