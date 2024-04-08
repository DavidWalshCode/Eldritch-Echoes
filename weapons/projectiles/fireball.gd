extends Projectile

@onready var area_damage_emitter = $AreaDamageEmitter
@onready var fireball_explosion_sounds = $Audio/FireballExplosionSounds.get_children()

func on_hit(hit_collider : Node3D, hit_position : Vector3, hit_normal : Vector3):
	super(hit_collider, hit_position, hit_normal)
	
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()
	$FireballSparkParticles.restart()
	play_fireball_explosion_sound()
	
	await get_tree().create_timer(0.15).timeout
	$FireballSmokeParticles.restart()
	
func play_fireball_explosion_sound():
	fireball_explosion_sounds[randi() % fireball_explosion_sounds.size()].play() # Randomly play an explosion sound
