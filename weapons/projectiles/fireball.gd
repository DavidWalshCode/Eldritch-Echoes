extends Projectile

@onready var area_damage_emitter = $AreaDamageEmitter
@onready var explosion_sounds = $Audio/ExplosionSounds.get_children()

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	super(hit_collider, hit_position, hit_normal)
	
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()

	#$ExplosionSparkParticles.restart()
	$ExplosionSparkParticles.emitting = true
	play_explosion_sound()
	
	await get_tree().create_timer(0.15).timeout
	#$ExplosionSmokeParticles.restart()
	$ExplosionSmokeParticles.emitting = true

func play_explosion_sound():
	explosion_sounds[randi() % explosion_sounds.size()].play() # Randomly play an explosion sound
