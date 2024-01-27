extends Node2D
var closeButton:Button
var invopen = true
func _ready():
	closeButton = get_node("closeButton")
	closeButton.connect("pressed",invClose)
	closeButton.disabled = false
func invClose():
	self.visible = false
	closeButton.disabled = true
func invToggle():
	self.visible = !self.visible
	closeButton.disabled = !closeButton.disabled
	print(closeButton.disabled)
	var invopen = !invopen
func _process(delta):
	if(Input.is_action_just_pressed("inventory_toggle")):
		invToggle()
