extends Node3D

@onready var ambience_level_3 = $Audio/AmbienceLevel3

func _ready():
	ambience_level_3.play()
