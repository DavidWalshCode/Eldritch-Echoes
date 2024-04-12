extends Node3D

@export var max_global_enemies = 10

var total_enemies_spawned = 0

func _ready():
	var spawners = get_children()  # Assuming all children are spawners
	for spawner in spawners:
		spawner.connect("enemy_spawned", Callable(self, "_on_enemy_spawned"))
		spawner.connect("enemy_despawned", Callable(self, "_on_enemy_despawned"))

func _on_enemy_spawned():
	total_enemies_spawned += 1
	print("Total enemies spawned: ", total_enemies_spawned)
	update_spawners()

func _on_enemy_despawned():
	total_enemies_spawned -= 1
	print("Total enemies currently: ", total_enemies_spawned)
	update_spawners()

func update_spawners():
	var allow_spawn = total_enemies_spawned < max_global_enemies
	for spawner in get_children():
		spawner.set_process(allow_spawn)
