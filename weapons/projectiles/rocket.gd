extends Projectile

@onready var area_damage_emitter = $AreaDamageEmitter
@onready var explosion_fireballs = $ExplosionFireballs.get_children()

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	super(hit_collider, hit_position, hit_normal)
	$TrailSmokeParticles.emitting = false
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()
	
	#$ExplosionFireball.restart()
	explosion_fireballs[randi() % explosion_fireballs.size()].restart() # Randomly show an explosion effect
	$ExplosionSparkParticles.restart()
	
	await get_tree().create_timer(0.15).timeout
	$ExplosionSmokeParticles.restart()
