extends KinematicBody
onready var health_manager = $HealthManager
enum STATES {IDLE, CHASE, ATTACK, DEAD}
var cur_state = STATES.IDLE

func _ready():
	
	health_manager.connect("gibbed", $Armature/Skeleton/Velociraptor, "hide")

	var bone_attatchments = $Armature/Skeleton.get_children()
	for bone_attatchment in bone_attatchments:
		if bone_attatchment is HitBox:
			for child in bone_attatchment:
				if child is HitBox:
					child.connect("hurt", self, "hurt")
		health_manager.connect("dead", self, "set_state_dead")
		set_state_idle()

func _process(delta):
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	cur_state = STATES.IDLE
func set_state_chase():
	cur_state = STATES.CHASE
func set_state_attack():
	cur_state = STATES.ATTACK
func set_state_dead():
	cur_state = STATES.DEAD

func process_state_idle(delta):
	pass
func process_state_chase(delta):
	pass
func process_state_attack(delta):
	pass
func process_state_dead(delta):
	pass

func hurt(damage: int, dir: Vector3):
	health_manager.hurt(damage, dir)

