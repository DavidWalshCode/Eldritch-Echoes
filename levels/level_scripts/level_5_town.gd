extends Node3D

@onready var ambience_level_5 = $Audio/AmbienceLevel5

func _ready():
	ambience_level_5.play()
