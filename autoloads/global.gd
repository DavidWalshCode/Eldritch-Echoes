extends Node

enum GLOBAL_STATE {
	MAIN_MENU,
	GAMEPLAY,
	CONVERSATION,
	PAUSED
}

const LANGUAGES : Dictionary = {
	0 : "en-ie",
	1 : "es-mx",
	2 : "zh-cn",
	3 : "hi"
}

var user_prefs : UserPrefs

var settings_menu_scene : PackedScene = preload("res://ui/menus/settings_menu.tscn")
var settings_menu = null

var main_menu = false

var main_dialogue_balloon_scene : PackedScene = preload("res://dialogue/dialogue_balloons/main_dialogue_balloon.tscn")
var main_dialogue_balloon = null

var death_count = 0 # Keeping track of the player death count
var debug # Reference to DebugPanel for debug property assignment

# Level specifc varaiables used for NPC dialogue
var is_level_1 = false
var is_level_2 = false
var is_level_3 = false
var is_level_4 = false
var is_level_5 = false

# Level specifc varaiables used for unlocking weapons and endings
var level_1_survived_passed_time = false
var level_2_survived_passed_time = false
var level_3_survived_passed_time = false
var level_4_survived_passed_time = false
var level_5_survived_passed_time = false

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var AMBIENCE_BUS_ID = AudioServer.get_bus_index("Ambience")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var UI_BUS_ID = AudioServer.get_bus_index("UI")
 
func _ready():
	user_prefs = UserPrefs.load_or_create()
	
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(user_prefs.master_volume))
	AudioServer.set_bus_mute(MASTER_BUS_ID, user_prefs.master_volume < .05)
	
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(user_prefs.sfx_volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, user_prefs.sfx_volume < .05)
	
	AudioServer.set_bus_volume_db(AMBIENCE_BUS_ID, linear_to_db(user_prefs.ambience_volume))
	AudioServer.set_bus_mute(AMBIENCE_BUS_ID, user_prefs.ambience_volume < .05)
	
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, user_prefs.music_volume < .05)
	
	AudioServer.set_bus_volume_db(UI_BUS_ID, linear_to_db(user_prefs.ui_volume))
	AudioServer.set_bus_mute(UI_BUS_ID, user_prefs.ui_volume < .05)

func get_selected_language() -> String:
	var s : String = LANGUAGES[user_prefs.language]
	if s:
		return s
	return LANGUAGES[0]

func open_settings_menu():
	if not settings_menu:
		settings_menu = settings_menu_scene.instantiate()
		get_tree().root.add_child(settings_menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		push_warning('Settings menu already exists in this scene')

func open_dialogue():
	if not main_dialogue_balloon:
		main_dialogue_balloon = main_dialogue_balloon_scene.instantiate()
		get_tree().root.add_child(main_dialogue_balloon)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		push_warning('Dialogue balloon already exists in this scene')
