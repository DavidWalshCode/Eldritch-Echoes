extends Node

enum GLOBAL_STATE {
	MAIN_MENU,
	GAMEPLAY,
	CONVERSATION,
	PAUSED
}

const LANGUAGES : Dictionary = {
	0:"en-US",
	1:"es-LAT"
}

var user_prefs : UserPrefs

# Temp: Not wild about preloads, but this menu is fairly light (to revise in a future version)
var settings_menu_scene : PackedScene = preload("res://ui/menus/settings_menu.tscn")
var settings_menu = null

var death_count = 0 # Keeping track of the player death count
var debug # Reference to DebugPanel for debug property assignment

# Level specifc varaiables
var level_1_survived_passed_time = false # Used for unlocking the machine gun
var level_2_survived_passed_time = false # Used for unlocking the shotgun
var level_3_survived_passed_time = false # Used for unlocking the grenade launcher
var level_4_survived_passed_time = false # Maybe used for another chance at getting a weapon unlock if died before
var level_5_survived_passed_time = false # Used for determining which ending the player gets

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
 
func _ready():
	user_prefs = UserPrefs.load_or_create()
	
	# temp - Will probably relocate to an audio-specfiic class in future versions
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(user_prefs.sfx_volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, user_prefs.sfx_volume < .05)
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, user_prefs.music_volume < .05)

func get_selected_language() -> String:
	var s : String = LANGUAGES[user_prefs.language]
	if s:
		return s
	return LANGUAGES[0]

# Temp: Maybe the settings menu doesn't need to live in a global spot? (will decide in future version)
func open_settings_menu():
	if not settings_menu:
		settings_menu = settings_menu_scene.instantiate()
		get_tree().root.add_child(settings_menu)
	else:
		push_warning('settings menu already exists in this scene')
