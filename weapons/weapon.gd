extends Node3D

class_name Weapon

signal fired
signal out_of_ammo

@export var min_pitch_scale = 0.9
@export var max_pitch_scale = 1.1
@export var automatic = false
@export var damage = 5
@export var ammo = 1000
@export var attack_rate = 0.2
@export var animation_controlled_attack = false
@export var recoil_strength = 0.8

var last_attack_time = -9999.9
var recoil_amount = 0.0

@onready var animation_player : AnimationPlayer = $Graphics/AnimationPlayer
@onready var attack_emitter : AttackEmitter = $AttackEmitter
@onready var fire_point : Node3D = %FirePoint
@onready var camera_3d = $"../../.."
@onready var shoot_sound = $Audio/ShootSound
@onready var out_of_ammo_sound = $Audio/OutOfAmmoSound

func _ready():
	attack_emitter.set_damage(damage)

func set_bodies_to_exclude(bodies : Array):
	attack_emitter.set_bodies_to_exclude(bodies)

func attack(input_just_pressed : bool, input_held : bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if ammo == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			out_of_ammo_sound.play()
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time < attack_rate:
		return
	
	if ammo > 0:
		ammo -= 1
	
	if !animation_controlled_attack:
		actually_attack()
	
	last_attack_time = current_time
	animation_player.stop()
	animation_player.play("attack")
	if has_node("Graphics/MuzzleFlash"):
		$Graphics/MuzzleFlash.flash()
	if has_node("Graphics/MuzzleFlash2"): # Not the best implementation for making the second flash show, keep an eye on it
		$Graphics/MuzzleFlash2.flash()
	
	play_shoot_sound()
	
	apply_recoil()

func actually_attack():
	attack_emitter.global_transform = fire_point.global_transform
	attack_emitter.fire()

func set_active(active : bool):
	#$Crosshair.visible = active
	visible = active
	if !active:
		animation_player.play("RESET", 0.3)

func apply_recoil():
	var steps = 8.0 # Number of steps to split the recoil into
	var recoil_step = recoil_strength / steps
	for i in range(steps):
		camera_3d.rotation_degrees.x += recoil_step
		await get_tree().create_timer(0.02).timeout # Wait for a short duration between each step

func play_shoot_sound():
	# Randomize pitch scale
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	shoot_sound.pitch_scale = random_pitch
	shoot_sound.play()

func is_idle() -> bool:
	return !animation_player.is_playing()
