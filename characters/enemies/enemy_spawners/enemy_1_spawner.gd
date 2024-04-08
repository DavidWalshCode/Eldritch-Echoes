extends Node3D

# Exported variables for setting in the editor
@export var enemy_scene = preload("res://characters/enemies/assets/scenes/bird_enemies_melee/bird_enemy_1_melee.tscn")
@export var spawn_interval_min = 2.0
@export var spawn_interval_max = 5.0  # Random range for spawn intervals
@export var max_enemies = 3  # Max number of enemies this spawner can handle

# Signals to inform the central manager about spawning activities
signal enemy_spawned
signal enemy_despawned

# Local variables
var enemies_spawned = 0
var spawn_timer = null

func _ready():
	randomize()
	spawn_timer = Timer.new()
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	start_spawning()

func start_spawning():
	set_process(true)
	_reset_timer()

func _reset_timer():
	spawn_timer.wait_time = rand_range(spawn_interval_min, spawn_interval_max)
	spawn_timer.start()

func _process(delta):
	'''
	if not is_processing():
		return

	if enemies_spawned < max_enemies:
		spawn_enemy()
		
	# The actual spawning process is triggered by the timer's timeout signal,
	# so there's no need to implement the spawning logic here directly.
	'''

func _on_spawn_timer_timeout():
	if is_processing() and enemies_spawned < max_enemies:
		_spawn_enemy()
		_reset_timer()  # Prepare for the next spawn

func _spawn_enemy():
	var enemy_instance = enemy_scene.instantiate()
	var enemy_health_manager = enemy_instance.get_node("EnemyHealthManager")
	enemy_health_manager.connect("enemy_died", Callable(self, "_on_enemy_despawned"))
	
	get_parent().add_child(enemy_instance)  # Add the enemy to the scene
	enemy_instance.global_transform = global_transform  # Position the enemy

	enemies_spawned += 1
	emit_signal("enemy_spawned")

func _on_enemy_despawned():
	emit_signal("enemy_despawned")
	enemies_spawned -= 1  # Adjust the count when an enemy is despawned

# Utility to randomly choose between the defined min and max intervals
func rand_range(min, max):
	return randf() * (max - min) + min
