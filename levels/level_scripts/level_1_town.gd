extends Node3D

@onready var ambience_level_1 = $Audio/AmbienceLevel1

func _ready():
	ambience_level_1.play()
