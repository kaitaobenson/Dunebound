extends ColorRect
var min_value = 0
var max_value = 100
var value = 0
signal scrolling
func isHovering(size,pos):
	return Rect2(pos, size).has_point(get_global_mouse_position())
# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("scroll").size = Vector2(self.size.x,max_value/self.size.y)
	pass
func _input(event):
	if(event is InputEventMouseMotion):
		if(isHovering(self.size,self.global_position) and Input.is_mouse_button_pressed( 1 )):
			get_node("scroll").global_position.y = get_global_mouse_position().y
			value = get_node("scroll").global_position.y-self.global_position.y
			scrolling.emit()
		#finish this goofy stuff at convention
func _process(delta):
	if(isHovering(self.size,self.global_position)):
		get_node("scroll").color = Color("#D9D2D2")
	else:
		get_node("scroll").color = Color("#878787")
	get_node("scroll").size = Vector2(self.size.x,self.size.y/max_value)
