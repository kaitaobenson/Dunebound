extends ColorRect
var leSillyGoober
var disabled =true
signal fakeButtonPressed
func isHovering(size,pos):
	return Rect2(pos, size).has_point(get_global_mouse_position())
func _input(event):
	if ((event is InputEventMouseButton and event.button_index==1) or event is InputEventMouseMotion):
		var pressed = event is InputEventMouseButton and event.button_index==1 and event.is_pressed()
		if(isHovering(self.size,self.global_position)):
			if(pressed and !disabled):
				fakeButtonPressed.emit()
func _ready():
	self.fakeButtonPressed.connect(cancelButtonPressed)
func cancelButtonPressed():
	leSillyGoober.cancelKeybindChange()
func cancelKeybindChange():
	self.visible = false
	self.disabled = true
func keybindChangeStarted():
	self.visible = true
	self.disabled = false
	
