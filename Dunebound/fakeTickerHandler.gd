extends ColorRect
@onready var up = get_node("up")
@onready var down = get_node("down")
@onready var text = get_node("Text")
var value = 0
var min_value = 0
var max_value = 0
signal value_changed
func _ready():
	pass # Replace with function body.
func isHovering(size,pos):
	return Rect2(pos, size).has_point(get_global_mouse_position())
func _input(event):
	if ((event is InputEventMouseButton and event.button_index==1) or event is InputEventMouseMotion):
		var pressed = event is InputEventMouseButton and event.button_index==1 and event.is_pressed()
		if(isHovering(up.size,up.global_position)):
			if(pressed):
				if(!int(value)+1>max_value):
					text.text = str(int(text.text)+1)
					value = text.text
					value_changed.emit()
		if(isHovering(down.size,down.global_position)):
			if(pressed):
				if(!int(value)-1<min_value):
					text.text = str(int(text.text)-1)
					value = text.text
					value_changed.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
