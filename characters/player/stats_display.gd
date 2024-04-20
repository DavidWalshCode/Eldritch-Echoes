extends Label

var ammo = 0
var health = 0

func update_ammo(amount):
	ammo = amount
	update_ammo_display()

func update_health(amount):
	health = amount
	update_health_display()

func update_health_display():
	text = "HEALTH: " + str(health)

func update_ammo_display():
	var ammo_amount = str(ammo)
	if ammo < 0: # For the sword
		ammo_amount = "INFINITE"
	
	text = "AMMO: " + ammo_amount
