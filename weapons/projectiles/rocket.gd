extends Projectile

@onready var area_damage_emitter = $AreaDamageEmitter

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	super(hit_collider, hit_position, hit_normal)
	$TrailSmokeParticles.emitting = false
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()
	
	$ExplosionFireball.restart()
	$ExplosionSparkParticles.restart()
	
	await get_tree().create_timer(0.15).timeout
	$ExplosionSmokeParticles
