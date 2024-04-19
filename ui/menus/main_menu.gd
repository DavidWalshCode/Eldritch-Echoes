class_name StartScreen extends Control

const template_version : String = "0.5"

@onready var version_num : Label = %VersionNum
@onready var main_menu_ambience = $MainMenuAmbience

func _ready() -> void:
	version_num.text = "v%s" % template_version

func _on_start_button_up() -> void:
	main_menu_ambience.queue_free()
	SceneManager.swap_scenes(SceneRegistry.levels["level_1_town"], get_tree().root, self, "fade_to_black") # Structure for swaping scenes: Level to swap to, the current scene, the transition

func _on_settings_button_up() -> void:
	Global.open_settings_menu()

func _on_quit_button_up() -> void:
	# TODO: Add confirmation dialog before quitting
	get_tree().quit()
