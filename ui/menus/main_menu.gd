class_name StartScreen extends Control

const template_version : String = "0.1"

@onready var version_num : Label = %VersionNum

func _ready() -> void:
	version_num.text = "v%s" % template_version

func _on_start_button_up() -> void:
	# Structure for swaping scenes: Level to swap to, the current scene, the transition
	SceneManager.swap_scenes(SceneRegistry.levels["level_1_town"], get_tree().root, self, "fade_to_black")

func _on_settings_button_up() -> void:
	Global.open_settings_menu()

func _on_quit_button_up() -> void:
	# TODO: Add confirmation dialog before quitting
	get_tree().quit()
