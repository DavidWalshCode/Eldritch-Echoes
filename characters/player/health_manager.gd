extends Node3D

signal died
signal healed
signal damaged
signal health_changed(current_health, max_health)

@export var max_health = 100
@export var verbose = true

@export_category("Audio")
@export var min_pitch_scale = 0.9 # Pitch variation range
@export var max_pitch_scale = 1.0 # Pitch variation range

@onready var current_health = max_health
@onready var hurt_sounds = $Audio/HurtSounds.get_children()
@onready var death_sounds = $Audio/DeathSounds.get_children()

func _ready():
	health_changed.emit(current_health, max_health)
	if verbose:
		print("Current Health: %s\nMax Health: %s" % [current_health, max_health])

func hurt(damage_data : DamageData):
	if current_health <= 0:
		return
		
	current_health -= damage_data.amount
	
	if current_health <= 0:
		#play_death_sound()
		died.emit()
	else:
		play_hurt_sound()
		damaged.emit()
	health_changed.emit()
	if verbose:
		print("Damaged for %s\nCurrent Health: %s/%s" % [damage_data.amount, current_health, max_health])

func heal(amount : int):
	if current_health <= 0:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)
	if verbose:
		print("Healed for %s\nHealth: %s/%s" % [amount, current_health, max_health])

func play_death_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	var death_sound_selected = death_sounds[randi() % death_sounds.size()]
	death_sound_selected.pitch_scale = random_pitch
	death_sound_selected.play()

func play_hurt_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	var hurt_sound_selected = hurt_sounds[randi() % hurt_sounds.size()]
	hurt_sound_selected.pitch_scale = random_pitch
	hurt_sound_selected.play()

