extends Node3D

@export var damage = 5

@onready var attack_emitter = $AttackEmitter

func _ready():
	attack_emitter.set_damage(damage)

func aim_at_position(position : Vector3):
	rotation = Vector3.ZERO
	var offset = to_local(position)
	offset.x = 0
	rotation.x = -atan2(offset.y, offset.z)
	

