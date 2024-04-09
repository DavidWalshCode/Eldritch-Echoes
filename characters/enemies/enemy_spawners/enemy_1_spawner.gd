extends Node3D

# Signals to inform the central manager about spawning activities
signal enemy_spawned
signal enemy_despawned

@export_category("Spawning")
@export var bird_enemy_melee_scene = preload("res://characters/enemies/assets/scenes/bird_enemies_melee/bird_enemy_1_melee.tscn")
@export var spawn_interval_min = 2.0
@export var spawn_interval_max = 5.0  # Random range for spawn intervals
@export var max_enemies = 3  # Max number of enemies this spawner can handle

@export_category("Audio")
@export var min_pitch_scale = 0.9
@export var max_pitch_scale = 1.1

var enemies_spawned = 0
var spawn_timer = null

@onready var enemy_1_spawn_sound = $SpawnSound/Enemy1SpawnSound

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
	spawn_timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)
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
	var enemy_instance = bird_enemy_melee_scene.instantiate()
	var enemy_health_manager = enemy_instance.get_node("EnemyHealthManager")
	enemy_health_manager.connect("enemy_died", Callable(self, "_on_enemy_despawned"))
	
	# Spawn effects
	$Enemy1SpawnEffect/SpawnFlames.restart() 
	$Enemy1SpawnEffect/SpawnSmoke.restart()
	
	get_parent().add_child(enemy_instance)  # Add the enemy to the scene
	enemy_instance.global_transform = global_transform  # Position the enemy
	
	play_spawn_sound()
	
	enemies_spawned += 1
	emit_signal("enemy_spawned")

func _on_enemy_despawned():
	emit_signal("enemy_despawned")
	enemies_spawned -= 1  # Adjust the count when an enemy is despawned

func play_spawn_sound():
	# Randomize pitch scale
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	enemy_1_spawn_sound.pitch_scale = random_pitch
	enemy_1_spawn_sound.play()
