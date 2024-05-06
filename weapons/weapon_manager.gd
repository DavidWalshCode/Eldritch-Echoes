extends Node3D

signal ammo_changed
signal got_ammo

enum WEAPON_SLOTS {
	SWORD, 
	REVOLVERS,
	MACHINE_GUN, 
	SHOTGUN, 
	ROCKET_LAUNCHER
}

@export_category("Audio")
@export var min_pitch_scale = 0.9 # Pitch variation range
@export var max_pitch_scale = 1.0 # Pitch variation range

var weapons_unlocked = []
var current_slot = 0
var current_weapon = null

var weapon_slots_unlocked = {
	WEAPON_SLOTS.SWORD : true,
	WEAPON_SLOTS.REVOLVERS : true,
	WEAPON_SLOTS.MACHINE_GUN : true, # false
	WEAPON_SLOTS.SHOTGUN : true, # false
	WEAPON_SLOTS.ROCKET_LAUNCHER : true # false
}

@onready var weapons = $Weapons.get_children()
@onready var general_weapon_animations = $GeneralWeaponAnimations
@onready var alert_area_hearing = $AlertAreaHearing
@onready var alert_area_line_of_sight = $AlertAreaLineOfSight
@onready var switch_sound = $SwitchSound
@onready var ammo_pickup_sound = $"../../ItemPickupManager/Audio/AmmoPickupSound"

func _ready():
	for weapon in weapons:
		if weapon.has_method("set_bodies_to_exclude"):
			weapon.set_bodies_to_exclude([get_parent().get_parent()]) # Excludes the player and camera, knows dont hit the player
	
	disable_all_weapons()
	check_weapon_unlocks()
	switch_to_weapon_slot(WEAPON_SLOTS.SWORD)
	
	for weapon in weapons:
			weapon.connect("fired", Callable(self, "alert_nearby_enenmies"))
			weapon.connect("fired", Callable(self, "emit_ammo_changed_signal"))
	
func attack(input_just_pressed : bool, input_held : bool):
	if current_weapon is Weapon:
		current_weapon.attack(input_just_pressed, input_held)

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_active"):
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

func switch_to_weapon_slot(slot_index : int) -> bool:
	if slot_index >= weapons.size() or slot_index < 0:
		return false
	
	if weapon_slots_unlocked.size() == 0 or !weapon_slots_unlocked[slot_index]:
		return false
		
	disable_all_weapons()
	
	current_slot = slot_index
	current_weapon = weapons[current_slot]
	
	if current_weapon.has_method("set_active"):
		current_weapon.set_active(true)
		general_weapon_animations.play("switch")  # , 0.4
		play_switch_sound()
	else:
		current_weapon.show()
	
	emit_ammo_changed_signal()
	
	return true

func unlock_weapon(slot_index : int):
	if slot_index < 0 or slot_index >= weapon_slots_unlocked.size():
		return # Invalid

	if not weapon_slots_unlocked[slot_index]:
		weapon_slots_unlocked[slot_index] = true

func check_weapon_unlocks():
	# Check and unlock sequentially without skipping
	if (Global.level_1_survived_passed_time or Global.level_2_survived_passed_time or Global.level_3_survived_passed_time or Global.level_4_survived_passed_time) and not weapon_slots_unlocked[WEAPON_SLOTS.MACHINE_GUN]:
		unlock_weapon(WEAPON_SLOTS.MACHINE_GUN)
		switch_to_weapon_slot(WEAPON_SLOTS.MACHINE_GUN)
	
	if (Global.level_2_survived_passed_time or Global.level_3_survived_passed_time or Global.level_4_survived_passed_time) and not weapon_slots_unlocked[WEAPON_SLOTS.SHOTGUN]:
		unlock_weapon(WEAPON_SLOTS.SHOTGUN)
		switch_to_weapon_slot(WEAPON_SLOTS.SHOTGUN)
	
	if (Global.level_3_survived_passed_time or Global.level_4_survived_passed_time) and not weapon_slots_unlocked[WEAPON_SLOTS.ROCKET_LAUNCHER]:
		unlock_weapon(WEAPON_SLOTS.ROCKET_LAUNCHER)
		switch_to_weapon_slot(WEAPON_SLOTS.ROCKET_LAUNCHER)

func update_move_animation(velocity : Vector3, grounded : bool):
	if current_weapon is Weapon and !current_weapon.is_idle():
		general_weapon_animations.play("idle", 0.4)
	elif !grounded or velocity.length() < 2.0:
		general_weapon_animations.play("idle", 0.4)
	else:
		general_weapon_animations.play("moving", 0.4)

func alert_nearby_enemies():
	var nearby_enemies = alert_area_line_of_sight.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert()
			
	nearby_enemies = alert_area_hearing.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert(false)

func get_item_pickup(item_pickup_type, ammo):
	match item_pickup_type:
		ItemPickup.ITEM_PICKUP_TYPES.REVOLVER_AMMO:
			weapons[1].ammo += ammo
			play_ammo_pickup_sound()

		ItemPickup.ITEM_PICKUP_TYPES.MACHINE_GUN_AMMO:
			weapons[2].ammo += ammo
			play_ammo_pickup_sound()

		ItemPickup.ITEM_PICKUP_TYPES.SHOTGUN_AMMO:
			weapons[3].ammo += ammo
			play_ammo_pickup_sound()

		ItemPickup.ITEM_PICKUP_TYPES.ROCKET_LAUNCHER_AMMO:
			weapons[4].ammo += ammo
			play_ammo_pickup_sound()

	emit_ammo_changed_signal()
	got_ammo.emit()

func emit_ammo_changed_signal():
	ammo_changed.emit(current_weapon.ammo)

func play_switch_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	switch_sound.pitch_scale = random_pitch
	switch_sound.play()

func play_ammo_pickup_sound():
	var random_pitch = randf_range(min_pitch_scale, max_pitch_scale)
	ammo_pickup_sound.pitch_scale = random_pitch
	ammo_pickup_sound.play()
