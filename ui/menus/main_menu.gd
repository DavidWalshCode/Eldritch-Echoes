class_name StartScreen extends Control

const template_version : String = "1.0"

@onready var version_num : Label = %VersionNum
@onready var main_menu_ambience = $MainMenuAmbience

func _ready() -> void:
	Global.main_menu = true
	version_num.text = "V%s" % template_version
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_up() -> void:
	main_menu_ambience.queue_free()
	Global.main_menu = false
	
	# Structure for swaping scenes: Level to swap to, the current scene, the transition
	SceneManager.swap_scenes(SceneRegistry.levels["level_1_town"], get_tree().root, self, "fade_to_black") 

func _on_settings_button_up() -> void:
	Global.open_settings_menu()

func _on_quit_button_up() -> void:
	# TODO: Add confirmation dialog before quitting
	get_tree().quit()
