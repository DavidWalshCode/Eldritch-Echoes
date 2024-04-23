extends Node3D

@onready var ambience_level_4 = $Audio/AmbienceLevel4
@onready var rain_ambience_level_4 = $Audio/RainAmbienceLevel4
@onready var intro_sting_level_4 = $Audio/IntroStingLevel4

func _ready():
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = false
	Global.is_level_3 = false
	Global.is_level_4 = true
	Global.is_level_5 = false
	
	intro_sting_level_4.play()
	rain_ambience_level_4.play()
	
	await get_tree().create_timer(4).timeout
	ambience_level_4.play()
