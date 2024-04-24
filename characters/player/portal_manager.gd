extends Area3D

signal portal_entered

@onready var portal_enter_sound = $Audio/PortalEnterSound

var player = null

func _ready():
	connect("area_entered", Callable(self, "on_area_entered"))
	player = get_tree().get_nodes_in_group("player")[0]

func on_area_entered(portal : Portal):
	portal_enter_sound.play()
	portal_entered.emit()
	
	await get_tree().create_timer(3).timeout
	
	if portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_1:
		player.load_level_through_portal(1)
	
	elif portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_2:
		player.load_level_through_portal(2)
	
	elif portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_3:
		player.load_level_through_portal(3)
	
	elif portal.portal_type == Portal.PORTAL_TYPES.TOWN_PORTAL_4:
		player.load_level_through_portal(4)
