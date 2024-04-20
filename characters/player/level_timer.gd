extends Label

var time : float = 0.0
var minutes : int = 0
var seconds : int = 0

var timer_on = false

func _ready():
	# reset_timer()
	update_time_display()  # Ensure initial time is displayed correctly

'''
func _process(delta) -> void:
	if timer_on:
		time += delta # time -+ delta for countdown timer
		minutes = fmod(time, 3600) / 60
		seconds = fmod(time, 60)
		
		$".".text = "%02d:" % minutes # Minutes text
		$"../SecondsLabel".text = "%02d" % seconds # Seconds text
'''

func _process(delta):
	if timer_on:
		time += delta  # time -+ delta for countdown timer instead of counting up
		update_time_display()

func update_time_display():
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	text = "%02d:%02d" % [minutes, seconds]  # Update the label text

func start_timer():
	timer_on = true
	set_process(true)  # Enable processing to update the timer

func stop_timer():
	timer_on = false
	set_process(false)  # Disable processing to stop updating the timer

func reset_timer():
	time = 0.0
	update_time_display()  # Reset the timer to 00:00

func get_time() -> float:
	return time

func get_time_formatted() -> String:
	return "%02d:02d" % [minutes, seconds]
