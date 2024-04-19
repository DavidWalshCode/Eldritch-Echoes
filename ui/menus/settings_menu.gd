class_name SettingsMenu extends CanvasLayer

# Opening this menu pauses the game, so you don't have to worry about blocking input from anything underneath it

# TODO: Implement fullscreen / window size dropdown Ex:
#	640×360
#	960×540
#	1920×1080
#	1280×720 with a scaling factor of 2.

signal language_changed(language : String)

@onready var master_slider : HSlider = %MasterSlider as HSlider
@onready var sfx_slider : HSlider = %SFXSlider as HSlider
@onready var ambience_slider : HSlider = %AmbienceSlider as HSlider
@onready var music_slider : HSlider = %MusicSlider as HSlider
@onready var ui_slider : HSlider = %UISlider as HSlider

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var AMBIENCE_BUS_ID = AudioServer.get_bus_index("Ambience")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var UI_BUS_ID = AudioServer.get_bus_index("UI")

@onready var language_dropdown : OptionButton = %LanguageDropdown as OptionButton
@onready var close_button : Button = %CloseButton as Button
@onready var save_button : Button = %SaveButton as Button
@onready var quit_button : Button = %QuitButton as Button

var user_prefs : UserPrefs

func _ready():
	# Load (or create) file with these saved preferences
	user_prefs = UserPrefs.load_or_create()
	
	# Note: If you want the option to save your game from this menu, replace the hardcoded false with logic that assures the game is in a savable state
	save_button.visible = false
	
	# Set saved values (will be default values if first load)
	if master_slider:
		master_slider.value = user_prefs.master_volume
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_volume
	if ambience_slider:
		ambience_slider.value = user_prefs.ambience_volume
	if music_slider:
		music_slider.value = user_prefs.music_volume
	if ui_slider:
		ui_slider.value = user_prefs.ui_volume
	if language_dropdown:
		language_dropdown.selected = user_prefs.language

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close_settings()

func close_settings():
	queue_free()

func _on_close_button_pressed():
	close_settings()
	
func _on_save_button_pressed():
	print("save button pressed")
	# Note: This is where I would/will put the ability for players to manually save data
	# Ex: something like the below
	# Globals.user_save.save_all_game_data()

func _on_quit_button_pressed():
	# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
	# TODO: Are you sure prompt
	# TODO: Save before quitting if in-game
	get_tree().quit()

func _on_master_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, _value < .05)
	user_prefs.master_volume = _value

func _on_sfx_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(SFX_BUS_ID, _value < .05)
	user_prefs.sfx_volume = _value

func _on_ambience_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(AMBIENCE_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(AMBIENCE_BUS_ID, _value < .05)
	user_prefs.ambience_volume = _value

func _on_music_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, _value < .05)
	user_prefs.music_volume = _value

func _on_ui_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(UI_BUS_ID, linear_to_db(_value))
	AudioServer.set_bus_mute(UI_BUS_ID, _value < .05)
	user_prefs.ui_volume = _value

func _on_language_dropdown_item_selected(_index):
	# TODO: Set selected language
	user_prefs.language = _index
	# TODO: Needs to be wired to a more central place for handling loc (planned for future version)
	language_changed.emit(_index)

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			user_prefs.save()
			get_tree().paused = false
