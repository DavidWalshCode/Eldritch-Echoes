extends AttackEmitter

@onready var line_of_sight_ray_cast = $LineOfSightRayCast
@export var attack_radius := 1.0
@export var offset_by_radius = false

func fire():
	var query_params := PhysicsShapeQueryParameters3D.new()
	query_params.shape = SphereShape3D.new()
	query_params.shape.radius = attack_radius
	query_params.collision_mask = 2
	var new_transform = global_transform
	
	if offset_by_radius:
		new_transform.origin = to_global(Vector3.FORWARD * attack_radius)
	
	query_params.transform = new_transform
	query_params.exclude = bodies_to_exclude
	var intersect_results : Array[Dictionary] = get_world_3d().direct_space_state.intersect_shape(query_params)
	
	for intersect_data in intersect_results:
		var collider : Node3D = intersect_data.collider
		if collider.has_method("hurt") and has_line_of_sight(collider):
			var damage_data = DamageData.new()
			damage_data.amount = damage
			damage_data.hit_position = collider.global_position + Vector3.UP
			collider.hurt(damage_data)
	super()
	
func has_line_of_sight(collider : Node3D) -> bool:
	line_of_sight_ray_cast.enabled = true
	line_of_sight_ray_cast.target_position = line_of_sight_ray_cast.to_local(collider.global_position + Vector3.UP)
	line_of_sight_ray_cast.force_raycast_update()
	var in_line_of_sight = !line_of_sight_ray_cast.is_colliding()
	line_of_sight_ray_cast.enabled = false
	return in_line_of_sight
