extends Area3D

signal got_item_pickup

var max_player_health = 100
var current_player_health = 0

func _ready():
	connect("area_entered", Callable(self, "on_area_entered"))

func update_player_health(amount):
	current_player_health = amount

func on_area_entered(item_pickup : ItemPickup):
	if item_pickup.item_pickup_type == ItemPickup.ITEM_PICKUP_TYPES.HEALTH and current_player_health == max_player_health:
		return
		
	got_item_pickup.emit(item_pickup.item_pickup_type, item_pickup.ammo)
	item_pickup.queue_free()
