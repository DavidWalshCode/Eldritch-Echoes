extends Node3D

@onready var ambience_level_4 = $Audio/AmbienceLevel4

func _ready():
	ambience_level_4.play()
