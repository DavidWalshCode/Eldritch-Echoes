extends Node3D

@onready var ambience_level_3 = $Audio/AmbienceLevel3
@onready var rain_ambience_level_3 = $Audio/RainAmbienceLevel3
@onready var intro_sting_level_3 = $Audio/IntroStingLevel3

func _ready():
	intro_sting_level_3.play()
	rain_ambience_level_3.play()
	ambience_level_3.play()
	
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = false
	Global.is_level_3 = true
	Global.is_level_4 = false
	Global.is_level_5 = false
