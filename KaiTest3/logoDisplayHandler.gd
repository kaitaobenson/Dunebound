extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var displayTimer = get_node("logoDisplayTimer")
	displayTimer.wait_time = 2
	displayTimer.connect("timeout",self.die)
	displayTimer.start()
func die():
	self.queue_free()
