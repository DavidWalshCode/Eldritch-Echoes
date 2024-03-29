extends AttackEmitter

const PROJECTILES = [
	preload("res://weapons/projectiles/rocket.tscn")
]

enum PROJECTILE_TYPE {
	ROCKET
}

@export var projectile_type : PROJECTILE_TYPE

func fire():
	var projectile_instance : Projectile = PROJECTILES[projectile_type].instantiate()
	projectile_instance.global_transform = global_transform
	projectile_instance.damage = damage
	
	get_tree().get_root().add_child(projectile_instance)
	
	projectile_instance.add_to_group("instanced")
	projectile_instance.set_bodies_to_exclude(bodies_to_exclude)
	# get_tree().call_group("instanced", "queue_free") # For changing scenes, this deletes all the projectiles in between scenes
	super()
