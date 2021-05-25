extends Spatial

export var flash_time = 0.05
var timer : Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = flash_time
	timer.connect("timeout", self, "end_flash")
	hide()

func flash():
	timer.start()
	#rotation.z = rand_range(0.0, 2*PI)
	rotation.x = 0
	rotation.y = 0
	show()
	
func end_flash():
	hide()
