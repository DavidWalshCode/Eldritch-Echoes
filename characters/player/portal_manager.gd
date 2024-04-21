extends Area3D

signal portal_entered

@onready var portal_enter_sound = $Audio/PortalEnterSound

func _ready():
	connect("area_entered", Callable(self, "on_area_entered"))
	connect("area_exited", Callable(self, "on_area_exited"))

func on_area_entered(portal : Portal):
	print("Entered portal")
	portal_enter_sound.play()
	portal_entered.emit()
	
	await get_tree().create_timer(4).timeout
	
	Global.queue_free_scene()
	
	if portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_1:
		SceneManager.swap_scenes(SceneRegistry.levels["level_1_battlefield"], get_tree().root, self, "fade_to_black")
	
	if portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_2:
		SceneManager.swap_scenes(SceneRegistry.levels["level_2_battlefield"], get_tree().root, self, "fade_to_black")
	
	if portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_3:
		SceneManager.swap_scenes(SceneRegistry.levels["level_3_battlefield"], get_tree().root, self, "fade_to_black")
	
	if portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_4:
		SceneManager.swap_scenes(SceneRegistry.levels["level_4_battlefield"], get_tree().root, self, "fade_to_black")
