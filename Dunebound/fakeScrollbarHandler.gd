extends ColorRect
var min_value = 0
var max_value = 100
var value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("scroll").size = Vector2(self.size.x,max_value/self.size.y)
func _input(event):
	if(event is InputEventMouseMotion):
		pass
		#finish this goofy stuff at convention
func _process(delta):
	pass
