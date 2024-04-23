extends Node3D

@onready var ambience_level_1 = $Audio/AmbienceLevel1
@onready var intro_sting_level_1 = $Audio/IntroStingLevel1

func _ready():
	intro_sting_level_1.play()
	ambience_level_1.play()
	
	# For NPC dialogue
	Global.is_level_1 = true
	Global.is_level_2 = false
	Global.is_level_3 = false
	Global.is_level_4 = false
	Global.is_level_5 = false
