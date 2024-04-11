extends Node3D

func enable_gibs():
	for child in get_children():
		if "emitting" in child:
			child.emitting = true
