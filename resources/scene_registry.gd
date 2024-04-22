class_name SceneRegistry extends Node

# The idea is to centrailse these strings so that when the game needs refactoring the only changes have to be heref

const main_scenes = {
	"main_menu": "res://ui/menus/main_menu.tscn",
	"ending_survived": "res://levels/endings/ending_survived.tscn", # TO UPDATE SCENE PATH WHEN ENDINGS ARE CREATED
	"ending_died": "res://levels/endings/ending_survived.tscn" # TO UPDATE SCENE PATH WHEN ENDINGS ARE CREATED
}

const levels = {
	"level_1_town" : "res://levels/town/level_1_town.tscn",
	"level_1_battlefield" : "res://levels/battlefield/level_1_battlefield.tscn",
	"level_2_town" : "res://levels/town/level_2_town.tscn",
	"level_2_battlefield" : "res://levels/battlefield/level_2_battlefield.tscn",
	"level_3_town" : "res://levels/town/level_3_town.tscn",
	"level_3_battlefield" : "res://levels/battlefield/level_3_battlefield.tscn",
	"level_4_town" : "res://levels/town/level_4_town.tscn",
	"level_4_battlefield" : "res://levels/battlefield/level_4_battlefield.tscn",
	"level_5_town" : "res://levels/town/level_5_town.tscn"
}
