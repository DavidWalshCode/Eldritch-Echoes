extends Area3D

class_name Hitbox

signal hurt_signal(damage_data)

@export var weak_spot = false
@export var critical_damage_multiplier = 2

func hurt(damage_data : DamageData):
	if weak_spot:
		damage_data.amount *= critical_damage_multiplier
	
	emit_signal("hurt_signal", damage_data)
