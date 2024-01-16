extends Node
var leSillyGoober
func _ready():
	self.button_down.connect(cancelButtonPressed)
func cancelButtonPressed():
	leSillyGoober.cancelKeybindChange()
func cancelKeybindChange():
	self.visible = false
	self.disabled = true
func keybindChangeStarted():
	self.visible = true
	self.disabled = false
	
