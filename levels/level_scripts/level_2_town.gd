extends Node3D

@onready var ambience_level_2 = $Audio/AmbienceLevel2

func _ready():
	ambience_level_2.play()
	
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = true
	Global.is_level_3 = false
	Global.is_level_4 = false
	Global.is_level_5 = false
