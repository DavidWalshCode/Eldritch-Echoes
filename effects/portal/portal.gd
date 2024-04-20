extends Area3D

signal enter_portal
signal exit_portal

func _ready():
	connect("area_entered", Callable(self, "on_area_entered"))

func on_area_entered():
	print("Entered portal")
	enter_portal.emit()
	
	# Switch case for loading the battlefield level based on the player death count
	match Global.death_count: 
		0:
			# Load battlefield level 1, death count is 0
			$"..".queue_free() # Removing the Level1Town node
			SceneManager.swap_scenes(SceneRegistry.levels["level_1_battlefield"], get_tree().root, self, "fade_to_black")
		1:
			# Load battlefield level 2, death count is 1
			$"..".queue_free() # TO Removing the Level2Town node
			SceneManager.swap_scenes(SceneRegistry.levels["level_2_battlefield"], get_tree().root, self, "fade_to_black")
		2:
			# Load battlefield level 3, death count is 2
			$"..".queue_free() # Removing the Level3Town node
			SceneManager.swap_scenes(SceneRegistry.levels["level_3_battlefield"], get_tree().root, self, "fade_to_black")
		3:
			# Load battlefield level 4, death count is 3
			$"..".queue_free() # Removing the Level4Town node
			SceneManager.swap_scenes(SceneRegistry.levels["level_4_battlefield"], get_tree().root, self, "fade_to_black")
		_:
			# Default case
			queue_free()
			get_tree().quit() # To remove later
	
	return true
