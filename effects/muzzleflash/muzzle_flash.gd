extends Node3D

@export var flash_time := 0.05
var timer : Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = flash_time
	timer.one_shot = true
	timer.timeout.connect(end_flash)
	hide()

func flash():
	show()
	rotation.z = randf_range(0.0, TAU) # TAU is 360 degrees in radians
	timer.start()
	
func end_flash():
	hide()
