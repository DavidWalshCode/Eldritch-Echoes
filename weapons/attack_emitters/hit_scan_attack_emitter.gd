extends AttackEmitter

@export var only_hit_environment = false
@onready var ray_cast_3d = $RayCast3D

var hit_effect = preload("res://effects/bullet_hit_effect.tscn")

func set_bodies_to_exclude(bodies : Array):
	super(bodies)
	for body in bodies:
		ray_cast_3d.add_exception(body)

func fire():
	ray_cast_3d.enabled = true
	ray_cast_3d.force_raycast_update()
	
	if ray_cast_3d.is_colliding():
		var can_hurt = ray_cast_3d.get_collider().has_method("hurt")
		if can_hurt and only_hit_environment:
			pass
		elif can_hurt:
			var damage_data = DamageData.new()
			damage_data.amount = damage
			damage_data.hit_position = ray_cast_3d.get_collision_point()
			ray_cast_3d.get_collider().hurt(damage_data)
		else:
			# Basically want hit effect to face down the normal (be flat against the surface)
			var hit_effect_instance : Node3D = hit_effect.instantiate()
			get_tree().get_root().add_child(hit_effect_instance)
			var hit_position : Vector3 = ray_cast_3d.get_collision_point()
			var hit_normal : Vector3 = ray_cast_3d.get_collision_normal() 
			var look_at_position : Vector3 = hit_position + hit_normal
			hit_effect_instance.global_position = hit_position
			
			# If the normal is directly up or down, change the up direction. Because otherwise it will give an error
			if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
				hit_effect_instance.look_at(look_at_position, Vector3.RIGHT) # Set the direction to right
			else:
				hit_effect_instance.look_at(look_at_position)
			
			# Schedule the hit effect instance to be freed after a certain amount of time
			#var delay = 5.0 # Time in seconds before the hit effect is deleted
			#var timer = get_tree().create_timer(delay)
			#var callable = Callable(self, "_on_Timer_timeout").bind(hit_effect_instance)
			#timer.connect("timeout", callable)
	
	ray_cast_3d.enabled = false
	super()

#func _on_Timer_timeout(hit_effect_instance : Node3D):
	#hit_effect_instance.queue_free()
