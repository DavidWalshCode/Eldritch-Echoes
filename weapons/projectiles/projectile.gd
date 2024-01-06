class_name Projectile
extends Node3D

@onready var collision_ray_cast = $CollisionRayCast

@export var speed = 65
@export var show_after_time := 0.1
@export var delete_on_hit_after_time := -1.0

const MAX_PROJECTILE_LIFESPAN := 10.0
var bodies_to_exclude = []
var damage = 1

var last_position : Vector3

func _ready():
	hide()
	await get_tree().create_timer(show_after_time).timeout
	show()
	await get_tree().create_timer(MAX_PROJECTILE_LIFESPAN).timeout
	queue_free()
	
func set_bodies_to_exclude(bodies_to_be_excluded : Array):
	bodies_to_exclude = bodies_to_be_excluded
	for bodies in bodies_to_be_excluded:
		collision_ray_cast.add_exception(bodies)

func _physics_process(delta):
	process_movement(delta) # Seperated so can add different logic to projectiles, e.g. grenades with gravity (can overwrite process_movement in subclasses)
	check_collision()

func process_movement(delta):
	last_position = global_position
	global_position += -global_transform.basis.z * speed * delta

func check_collision():
	collision_ray_cast.global_position = last_position
	collision_ray_cast.target_position = collision_ray_cast.to_local(global_position)
	collision_ray_cast.enabled = true
	collision_ray_cast.force_raycast_update()
	
	var is_colliding = collision_ray_cast.is_colliding()
	var hit_position = collision_ray_cast.get_collision_point()
	var hit_normal = collision_ray_cast.get_collision_normal()
	var hit_collider = collision_ray_cast.get_collider()
	
	collision_ray_cast.enabled = false
	
	if is_colliding:
		on_hit(hit_collider, hit_position, hit_normal)

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	global_position = hit_position
	if hit_collider.has_method("hurt"):
		damage_target(hit_collider, hit_position, hit_normal)
	destroy()

func damage_target(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	var damage_data = DamageData.new()
	damage_data.amount = damage
	damage_data.hit_position = hit_position
	hit_collider.hurt(damage_data)

func destroy():
	if delete_on_hit_after_time > 0:
		$Graphics.hide()
		set_process(false)
		set_physics_process(false)
		await get_tree().create_timer(delete_on_hit_after_time).timeout
		queue_free()
	else:
		queue_free()
