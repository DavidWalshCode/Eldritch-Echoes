class_name SceneRegistry extends Node

# note I don't know if I'm going to like this structure, but we're going to field test it with this version.
# The idea is to centrailze these strings so that if/when I refactor the game I only
# have to change these in on place. (spoiler alert: I'm not a huge fan of find and replace)
# so we're going to minimize how much/often we have to use that until Godot gets proper refactoring :)

const main_scenes = {
	"main_menu": "res://ui/menus/main_menu.tscn",
	"ending_survived": "res://ui/menus/main_menu.tscn", # TO UPDATE SCENE PATH WHEN ENDINGS ARE CREATED
	"ending_died": "res://ui/menus/main_menu.tscn" # TO UPDATE SCENE PATH WHEN ENDINGS ARE CREATED
}

const levels = {
	"level_1_town" : "res://levels/town/level_1_town.tscn",
	"level_1_battlefield" : "res://levels/battlefield/level_1_battlefield.tscn",
	"level_2_town" : "res://levels/town/level_2_town.tscn",
	"level_2_battlefield" : "res://levels/battlefield/level_1_battlefield.tscn", # TO UPDATE SCENE PATH WHEN LEVEL IS CREATED
	"level_3_town" : "res://levels/town/level_3_town.tscn",
	"level_3_battlefield" : "res://levels/battlefield/level_1_battlefield.tscn", # TO UPDATE SCENE PATH WHEN LEVEL IS CREATED
	"level_4_town" : "res://levels/town/level_4_town.tscn",
	"level_4_battlefield" : "res://levels/battlefield/level_1_battlefield.tscn", # TO UPDATE SCENE PATH WHEN LEVEL IS CREATED
	"level_5_town" : "res://levels/town/level_5_town.tscn"
}
