extends Node3D

@export var max_global_enemies = 5

var total_enemies_spawned = 0
var spawning_enabled = false  # A flag to control whether spawning is allowed

func _ready():
	var spawners = get_children()  # Assuming all children are spawners
	for spawner in spawners:
		spawner.connect("enemy_spawned", Callable(self, "_on_enemy_spawned"))
		spawner.connect("enemy_despawned", Callable(self, "_on_enemy_despawned"))
		
	manager_stop_spawning()
	
func _on_enemy_spawned():
	total_enemies_spawned += 1
	print("Total enemies spawned: ", total_enemies_spawned)
	update_spawners()

func _on_enemy_despawned():
	total_enemies_spawned -= 1
	print("Total enemies currently: ", total_enemies_spawned)
	update_spawners()

func update_spawners():
	var allow_spawn = spawning_enabled and total_enemies_spawned < max_global_enemies
	for spawner in get_tree().get_nodes_in_group("spawners"):
		if allow_spawn:
			spawner.start_spawning()
		else:
			spawner.stop_spawning()
	
func manager_start_spawning():
	spawning_enabled = true
	update_spawners()

func manager_stop_spawning():
	spawning_enabled = false
	update_spawners()
