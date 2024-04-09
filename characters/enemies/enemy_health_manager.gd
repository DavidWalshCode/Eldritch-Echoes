extends Node3D

signal enemy_died
signal enemy_damaged
signal enemy_gibbed
signal enemy_health_changed(current_health, max_health)

@export var max_health = 100
@export var gib_at = -10
@export var verbose = true

@onready var current_health = max_health

func _ready():
	enemy_health_changed.emit(current_health, max_health)
	if verbose:
		print("Enemy Starting Health: %s/%s" % [current_health, max_health])

func hurt(damage_data : DamageData):
	if current_health <= 0:
		return
		
	current_health -= damage_data.amount

	if current_health <= gib_at:
		enemy_gibbed.emit()
	if current_health <= 0:
		enemy_died.emit()
	else:
		enemy_damaged.emit()
	enemy_health_changed.emit()
	if verbose:
		print("Enemy damaged for %s\nEnemy Current Health: %s/%s" % [damage_data.amount, current_health, max_health])

