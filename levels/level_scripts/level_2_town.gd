extends Node3D

@onready var ambience_level_2 = $Audio/AmbienceLevel2

func _ready():
	ambience_level_2.play()
