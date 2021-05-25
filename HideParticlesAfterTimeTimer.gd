extends KinematicBody

export var start_move_speed = 30
export var gravity = 35.0
export var drag = 0.01
export var velocity_retained_on_bounce = 0.8


var velocity = Vector3.ZERO
var initialized = false

func init():
	initialized = true
	velocity = -global_transform.basis.y * start_move_speed
	
func _physics_process(delta):
	if !initialized:
		return
	velocity += -velocity * drag + Vector3.DOWN * gravity* delta
	var collision = move_and_collide(velocity*delta)
	if collision:
		var d = velocity
		var n = collision.normal
		var r = d - 2 * d.dot(n) * n
		velocity = r * velocity_retained_on_bounce
		
