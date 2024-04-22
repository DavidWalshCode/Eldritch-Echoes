extends Area3D

const MAIN_BALLOON = preload("res://dialogue/dialogue_balloons/main_dialogue_balloon.tscn")

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

func action() -> void:
	var balloon : Node = MAIN_BALLOON.instantiate()
	get_tree().root.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
