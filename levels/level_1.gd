extends Node3D

@onready var ambience_1 = $Audio/Ambience1

func _ready():
	ambience_1.play()
