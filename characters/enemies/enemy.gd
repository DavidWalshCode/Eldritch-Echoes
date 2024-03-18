extends CharacterBody3D

func _ready():
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.connect("hit", Callable(self, "hurt"))

func hurt(damage : int, direction : Vector3):
	print("Enemy got hit")
