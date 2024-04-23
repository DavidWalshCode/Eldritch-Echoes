extends Node3D

@onready var ambience_level_2 = $Audio/AmbienceLevel2
@onready var intro_sting_level_2 = $Audio/IntroStingLevel2

func _ready():
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = true
	Global.is_level_3 = false
	Global.is_level_4 = false
	Global.is_level_5 = false
	
	intro_sting_level_2.play()
	
	await get_tree().create_timer(4).timeout
	ambience_level_2.play()
	
	
