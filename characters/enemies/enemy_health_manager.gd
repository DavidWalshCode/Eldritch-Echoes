extends Node3D

@export var max_health = 100
@onready var current_health = max_health
@export var gib_at = -10
@export var verbose = true

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(current_health, max_health)

func _ready():
	health_changed.emit(current_health, max_health)
	if verbose:
		print("Enemy Starting Health: %s/%s" % [current_health, max_health])

func hurt(damage_data : DamageData):
	if current_health <= 0:
		return
		
	current_health -= damage_data.amount

	if current_health <= gib_at:
		gibbed.emit()
	if current_health <= 0:
		died.emit()
	else:
		damaged.emit()
	health_changed.emit()
	if verbose:
		print("Enemy damaged for %s, Current Health: %s/%s" % [damage_data.amount, current_health, max_health])

func heal(amount : int):
	if current_health <= 0:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)
	if verbose:
		print("Enemy healed for %s, Health: %s/%s" % [amount, current_health, max_health])
