extends Area3D

class_name ItemPickup

enum ITEM_PICKUP_TYPES {
	REVOLVERS,
	REVOLVER_AMMO,
	MACHINE_GUN,
	MACHINE_GUN_AMMO,
	SHOTGUN,
	SHOTGUN_AMMO,
	ROCKET_LAUNCHER,
	ROCKET_LAUNCHER_AMMO,
	HEALTH
}

@export var item_pickup_type : ITEM_PICKUP_TYPES
@export var ammo = 10 # Ammo number also counts for how much health you gain from the health pickup
