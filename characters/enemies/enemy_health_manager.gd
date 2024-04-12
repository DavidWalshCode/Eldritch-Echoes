extends Node3D

signal enemy_died
signal enemy_damaged
signal enemy_gibbed
signal enemy_health_changed(current_health, max_health)

@export var max_health = 100
@export var gib_at = -10
@export var verbose = true

@export_category("Sound")
@export var min_pitch_scale = 0.9 # Pitch variation range
@export var max_pitch_scale = 1.0 # Pitch variation range

var blood_spray = preload("res://effects/gore/blood/blood_spray_effect.tscn")
var gibs = preload("res://effects/gore/gibs/gibs.tscn")

@onready var current_health = max_health
@onready var death_sounds = $Audio/DeathSounds.get_children()
@onready var hurt_sounds = $Audio/HurtSounds.get_children()

func _ready():
	enemy_health_changed.emit(current_health, max_health)
	if verbose:
		print("Enemy Starting Health: %s/%s" % [current_health, max_health])

func hurt(damage_data : DamageData):
	spawn_blood(damage_data.direction)
	
	if current_health <= 0:
		return
		
	current_health -= damage_data.amount

	if current_health <= gib_at:
		spawn_gibs()
		enemy_gibbed.emit()
	if current_health <= 0:
		enemy_died.emit()
	else:
		enemy_damaged.emit()
		
	enemy_health_changed.emit()
	
	if verbose:
		print("Enemy damaged for %s\nEnemy Current Health: %s/%s" % [damage_data.amount, current_health, max_health])

func spawn_blood(direction):
	''' # Way from updated hit_scan_emitter
	var blood_spray_instance : Node3D = blood_spray.instantiate()
	get_tree().get_root().add_child(blood_spray_instance)
	var hit_position : Vector3 = ray_cast_3d.get_collision_point()
	var hit_normal : Vector3 = ray_cast_3d.get_collision_normal() 
	var look_at_position : Vector3 = hit_position + hit_normal
	blood_spray_instance.global_position = hit_position
	
	# If the normal is directly up or down, change the up direction. Because otherwise it will give an error
	if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
		blood_spray_instance.look_at(look_at_position, Vector3.RIGHT) # Set the direction to right
	else:
		blood_spray_instance.look_at(look_at_position)
	'''
	
	var blood_spray_instance = blood_spray.instantiate()
	get_tree().get_root().add_child(blood_spray_instance)
	blood_spray_instance.global_transform.origin = global_transform.origin
	
	if direction.angle_to(Vector3.UP) < 0.00005:
		return
	if direction.angle_to(Vector3.DOWN) < 0.00005:
		blood_spray_instance.rotate(Vector3.RIGHT, PI)
		return
	
	var y = direction
	var x = y.cross(Vector3.UP)
	var z = x.cross(y)
	
	blood_spray_instance.global_transform.basis = Basis(x, y, z)

func spawn_gibs():
	var gibs_instance = gibs.instantiate()
	get_tree().get_root().add_child(gibs_instance)
	gibs_instance.global_transform.origin = global_transform.origin
	gibs_instance.enable_gibs()

func play_death_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	var death_sound_selected = death_sounds[randi() % death_sounds.size()]
	death_sound_selected.pitch_scale = random_pitch
	death_sound_selected.play()

func play_hurt_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	var hurt_sound_selected = hurt_sounds[randi() % hurt_sounds.size()]
	hurt_sound_selected.pitch_scale = random_pitch
	hurt_sound_selected.play()
