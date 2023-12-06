extends Node3D

class_name Weapon

@onready var animation_player : AnimationPlayer = $Graphics/AnimationPlayer
@onready var attack_emitter : AttackEmitter = $AttackEmitter
@onready var fire_point : Node3D = %FirePoint
@onready var camera_3d = $"../../.."
@onready var player = $"../../../.."

@export var automatic = false
@export var damage = 5
@export var ammo = 1000
@export var attack_rate = 0.2
@export var recoil_knockback_power = 10
var last_attack_time = -9999.9

signal fired
signal out_of_ammo

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
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time < attack_rate:
		return
	
	if ammo > 0:
		ammo -= 1
	
	attack_emitter.global_transform = fire_point.global_transform
	attack_emitter.fire()
	last_attack_time = current_time
	animation_player.stop()
	animation_player.play("attack")
	
	# Get camera direction at a normalised vector 3d
	# Recoil is take the direction youre firing in, reverse it and add some factor amount to the velocity
	var facing_direction = camera_3d.global_transform.basis.z
	player.velocity += facing_direction * 5
	
func recoil_knockback(recoil_knockback_power):
	#recoil(power):
		#player.x -= some_factor * power;
		#player.y -= some_BIG_factor * power;
		#player.z -= some_factor * power;
	return

func set_active(a : bool):
	visible = a
	if !a:
		animation_player.play("RESET")
