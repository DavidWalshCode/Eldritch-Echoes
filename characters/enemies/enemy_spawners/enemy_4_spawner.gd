extends Node3D

@export_category("Spawning")
@export var bird_enemy_melee_scene = preload("res://characters/enemies/assets/scenes/bird_enemies_melee/bird_enemy_1_melee.tscn")
@export var bird_enemy_ranged_scene = preload("res://characters/enemies/assets/scenes/bird_enemies_melee/bird_enemy_1_melee.tscn")
@export var reptile_enemy_melee_scene = preload("res://characters/enemies/assets/scenes/bird_enemies_melee/bird_enemy_1_melee.tscn")
@export var bird_enemy_melee_spawn_weight = 40
@export var bird_enemy_ranged_spawn_weight = 40
@export var reptile_enemy_meleed_spawn_weight = 20
@export var spawn_interval_min = 2.0
@export var spawn_interval_max = 5.0  # Random range for spawn intervals
@export var max_enemies = 3  # Max number of enemies this spawner can handle

@export_category("Audio")
@export var min_pitch_scale = 0.9
@export var max_pitch_scale = 1.1

@onready var enemy_4_spawn_sound = $SpawnSound/Enemy4SpawnSound

# Signals to inform the central manager about spawning activities
signal enemy_spawned
signal enemy_despawned

var enemies_spawned = 0
var spawn_timer = null

# Define enemy types and their spawn weights
var enemy_types = [
	{"scene": bird_enemy_melee_scene, "weight": bird_enemy_melee_spawn_weight},  # 40% chance to spawn
	{"scene": bird_enemy_ranged_scene, "weight": bird_enemy_ranged_spawn_weight},   # 40% chance to spawn
	{"scene": reptile_enemy_melee_scene, "weight": reptile_enemy_meleed_spawn_weight}   # 20% chance to spawn
]

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
	var total_weight = 0
	for enemy_type in enemy_types:
		total_weight += enemy_type["weight"]
		
	var random_pick = randi() % total_weight
	var current_sum = 0

	for enemy_type in enemy_types:
		current_sum += enemy_type.weight
		if random_pick < current_sum:
			var enemy_instance = enemy_type.scene.instantiate()  # var enemy_instance = enemy_scene.instantiate() 
			var enemy_health_manager = enemy_instance.get_node("EnemyHealthManager")
			enemy_health_manager.connect("enemy_died", Callable(self, "_on_enemy_despawned"))
			
			$Enemy4SpawnEffect/SpawnFlames.restart() # Spawn effects
			$Enemy4SpawnEffect/SpawnSmoke.restart() # Spawn effects
			
			get_parent().add_child(enemy_instance)
			enemy_instance.global_transform = global_transform
			
			play_spawn_sound()
			
			enemies_spawned += 1
			emit_signal("enemy_spawned")

			break  # Exit the loop once the enemy type is selected

func _on_enemy_despawned():
	emit_signal("enemy_despawned")
	enemies_spawned -= 1  # Adjust the count when an enemy is despawned

func play_spawn_sound():
	# Randomize pitch scale
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	enemy_4_spawn_sound.pitch_scale = random_pitch
	enemy_4_spawn_sound.play()
