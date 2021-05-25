extends Spatial


onready var anim_player = $Graphics/Arms_Glock_G48/AnimationPlayer
onready var bullet_emitters_base : Spatial = $Graphics/BulletEmitter
onready var bullet_emitters = $Graphics/BulletEmitter.get_children()

export var automatic = false

var fire_point : Spatial

var bodies_to_exclude : Array = []

export var damage = 5
export var ammo = 24

export var attack_rate = 0.2
var attack_timer : Timer
var can_attack = true
var reloading : bool
signal fired
signal reload
signal out_of_ammo

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", self, "finish_attack")
	attack_timer.one_shot = true
	add_child(attack_timer)
	
func init(_fire_point: Spatial, _bodies_to_exclude : Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for bullet_emitter in bullet_emitters:
		bullet_emitter.set_damage(damage)
		bullet_emitter.set_bodies_to_exclude(bodies_to_exclude)
		
func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if automatic and !attack_input_held:
		return
	elif !automatic and !attack_input_just_pressed:
		return
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo")
		return
	if ammo > 0:
		ammo -= 1
		print(ammo)
		var start_transform = bullet_emitters_base.global_transform
		bullet_emitters_base.global_transform = fire_point.global_transform
		for bullet_emitter in bullet_emitters:
			bullet_emitter.fire()
		bullet_emitters_base.global_transform = start_transform
		anim_player.stop()
		anim_player.play("Armature|Glock_Fire_Anim")
		emit_signal("fired")
		can_attack = false
		attack_timer.start()

func reload(reload_input_just_pressed: bool):
	anim_player.stop()
	emit_signal("reload")
	anim_player.play("Armature|Glock_Reload_Anim")
	ammo = 12
	
func walk (walk_input_is_pressed: bool):
	print("WALKING")
	if walk_input_is_pressed:
		anim_player.play("Armature|Glock_Walk_Anim")
	else:
		anim_player.stop()
	
func finish_attack():
	can_attack = true
		
func set_active():
	show()
	
func set_inactive():
	anim_player.play("Armature|Glock_Idle_Anim")	
	hide()	
		
		
		
