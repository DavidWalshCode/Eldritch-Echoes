extends Projectile

@onready var area_damage_emitter = $AreaDamageEmitter
@onready var explosion_fireballs = $ExplosionFireballs.get_children()
@onready var explosion_sounds = $Audio/ExplosionSounds.get_children()

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	super(hit_collider, hit_position, hit_normal)
	
	$TrailSmokeParticles.emitting = false
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()
	
	explosion_fireballs[randi() % explosion_fireballs.size()].restart() # Randomly show an explosion effect
	$ExplosionSparkParticles.restart()
	play_explosion_sound()
	
	await get_tree().create_timer(0.15).timeout
	$ExplosionSmokeParticles.restart()

func play_explosion_sound():
	explosion_sounds[randi() % explosion_sounds.size()].play() # Randomly play an explosion sound
