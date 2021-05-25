extends KinematicBody

var hotkeys = {KEY_1: 0, KEY_2: 1  , KEY_3:2  , KEY_4: 3 }

export var mouse_sens = 0.5

onready var camera = $Camera
onready var character_mover = $CharacterMover

onready var weapon_manager = $Camera/WeaponManager

onready var velorap = $Velociraptor
onready var health_manager = $HealthManager

var dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	weapon_manager.init($Camera/FirePoint, [self])
	health_manager.init()
	health_manager.connect("dead", self, "kill")
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if dead:
		return
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
		weapon_manager.walk(true)
	if Input.is_action_just_released("move_forwards"):
		weapon_manager.walk(false)
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
		weapon_manager.walk(true)
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
		weapon_manager.walk(true)
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
		weapon_manager.walk(true)
	character_mover.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	if Input.is_action_just_pressed("reload"):
		weapon_manager.reload(Input.is_action_just_pressed("reload"))
	weapon_manager.attack(Input.is_action_just_pressed("attack"), 
						  Input.is_action_pressed("attack"))
	
						
	#weapon_manager.reload(Input.is_action_pressed("reload"))

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -165, 0)
		
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()
		
func hurt(damage, dir):
	health_manager.hurt(damage, dir)
func heal(amount):
	health_manager.heal(amount)
func kill():
	dead = true
	character_mover.freeze()
	
