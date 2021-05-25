extends Node


enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

onready var weapons =$Weapons.get_children()
var cur_slot = 0
var cur_weapon = null
var fire_point : Spatial
var walking : bool
var bodies_to_exclude : Array = []
func _ready():
	pass
	
func init(_fire_point: Spatial, _bodies_to_exclude : Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method("init"):
			weapon.init(_fire_point , _bodies_to_exclude )
			print("WEAPON INIT")
	switch_to_weapon_slot(WEAPON_SLOTS.MACHINE_GUN)
	
func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if cur_weapon.has_method("attack"):
		cur_weapon.attack(attack_input_just_pressed, attack_input_held)

func reload(reload_input_just_pressed: bool):
	if cur_weapon.has_method("reload"):
		cur_weapon.reload(reload_input_just_pressed)
		
func walk(walk_input_is_pressed: bool):
	if cur_weapon.has_method("walk"):
		cur_weapon.walk(walk_input_is_pressed)
	
func switch_to_next_weapon():
	cur_slot = (cur_slot + 1) % slots_unlocked.size()
	if !slots_unlocked[cur_slot]:
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(cur_slot)
		
func switch_to_last_weapon():
	cur_slot = posmod((cur_slot - 1), slots_unlocked.size())
	if !slots_unlocked[cur_slot]:
		switch_to_last_weapon()
	else:
		switch_to_weapon_slot(cur_slot)
	
func switch_to_weapon_slot(slot_index : int):
	if slot_index < 0 or slot_index >= slots_unlocked.size():
		return
	if !slots_unlocked[cur_slot]:
		return
	disable_all_weapons()
	cur_weapon = weapons[slot_index]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.show()
		

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()
