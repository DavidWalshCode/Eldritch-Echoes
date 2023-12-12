extends Node3D

@onready var weapons = $Weapons.get_children()
var weapons_unlocked = []
var current_slot = 0
var current_weapon = null

func _ready():
	disable_all_weapons()
	for _i in range(weapons.size()):
		#weapons_unlocked.append(false)
		weapons_unlocked.append(true)
	switch_to_weapon_slot(0)

func attack(input_just_pressed : bool, input_held : bool):
	if current_weapon is Weapon:
		current_weapon.attack(input_just_pressed, input_held)

func disable_all_weapons():
	for weapon in weapons:
		if has_method("set_active"):
			weapon.set_active(false)
		else:
			weapon.hide()

func switch_to_previous_weapon():
	for i in range(weapons.size()):
		var wrapped_index = wrapi(current_slot - 1 - i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_index):
			break

func switch_to_next_weapon():
	for i in range(weapons.size()):
		var wrapped_index = wrapi(current_slot + 1 + i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_index):
			break

func switch_to_weapon_slot(slot_index : int)->bool:
	if slot_index >= weapons.size() or slot_index < 0:
		return false
	
	if weapons_unlocked.size() == 0 or !weapons_unlocked[slot_index]:
		return false
		
	disable_all_weapons()
	
	current_slot = slot_index
	current_weapon = weapons[current_slot]
	
	if has_method("set_active"):
		current_weapon.set_active(true)
	else:
		current_weapon.show()
		
	return true
