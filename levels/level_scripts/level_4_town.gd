extends Node3D

@onready var ambience_level_4 = $Audio/AmbienceLevel4

func _ready():
	ambience_level_4.play()
	
	# For NPC dialogue
	Global.is_level_1 = false
	Global.is_level_2 = false
	Global.is_level_3 = false
	Global.is_level_4 = true
	Global.is_level_5 = false
