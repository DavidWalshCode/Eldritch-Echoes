extends Node3D

@onready var ambience_level_1 = $Audio/AmbienceLevel1
@onready var music_level_1 = $Audio/MusicLevel1

func _ready():
	ambience_level_1.play()
	music_level_1.play()
