extends Node3D

signal enemy_died
signal enemy_damaged
signal enemy_gibbed
signal enemy_health_changed(current_health, max_health)

@export var max_health = 100
@export var gib_at = -10

@export_category("Sound")
@export var min_pitch_scale = 0.8 # Pitch variation range
@export var max_pitch_scale = 1.0 # Pitch variation range

var blood_spray = preload("res://effects/gore/blood/blood_spray_effect.tscn")
var gibs = preload("res://effects/gore/gibs/gibs.tscn")

@onready var current_health = max_health
@onready var death_sounds = $Audio/DeathSounds.get_children()
@onready var gib_sound = $Audio/GibSounds/GibSound1
@onready var hit_sound = $Audio/HitSounds/HitSound

func _ready():
	enemy_health_changed.emit(current_health, max_health)

func hurt(damage_data : DamageData):
	spawn_blood(damage_data.direction)
	hit_sound.play()
	
	if current_health <= 0:
		return
		
	current_health -= damage_data.amount

	if current_health <= gib_at:
		spawn_gibs()
		play_gib_sound()
		enemy_gibbed.emit()
	if current_health <= 0:
		play_death_sound()
		enemy_died.emit()
	else:
		enemy_damaged.emit()
		
	enemy_health_changed.emit()

func spawn_blood(direction):
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
	
func play_gib_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	gib_sound.pitch_scale = random_pitch
	gib_sound.play()
