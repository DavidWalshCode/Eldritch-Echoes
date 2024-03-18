extends Area3D

class_name Hitbox

@export var weak_spot = false
@export var critical_damage_multiplier = 2
signal hit

func hurt(damage : int, direction : Vector3):
	if weak_spot:
		emit_signal("hit", damage * critical_damage_multiplier, direction)
	else:
		emit_signal("hit", damage, direction)
