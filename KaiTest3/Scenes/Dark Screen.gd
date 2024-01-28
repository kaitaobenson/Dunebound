extends ColorRect

const SCREEN_X = 1152
const SCREEN_Y = 648

var timer = 0
var wait_time = 0.01

func _process(delta):
	if wait_time > 0:
		timer+=delta
		if timer>wait_time:
			wait_time = 0
			adjust()
			light()

#(-SCREEN_X / 2) is over the screen, but there is camera smoothing so we need buffer 
func adjust():
	self.position.x = (-SCREEN_X / 2) - 100
	self.position.y = (-SCREEN_Y / 2) - 100

func light():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 2)
