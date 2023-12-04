extends Node3D

class_name Weapon

@onready var animation_player : AnimationPlayer = $Graphics/AnimationPlayer
@onready var attack_emitter : AttackEmitter = $AttackEmitter
@onready var fire_point : Node3D = %FirePoint

@export var automatic = false
@export var damage = 5
@export var ammo = 30
@export var attack_rate = 0.2
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

func set_active(a : bool):
	visible = a
	if !a:
		animation_player.play("RESET")
