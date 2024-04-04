extends Node3D

func aim_at_position(position : Vector3):
	rotation = Vector3.ZERO
	var offset = to_local(position)
	offset.x = 0
	rotation.x = -atan2(offset.y, offset.z)
