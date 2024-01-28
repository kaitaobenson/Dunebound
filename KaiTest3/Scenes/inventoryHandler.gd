extends Node2D
var closeButton:Button
func _ready():
	self.visible = false
	closeButton = get_node("closeButton")
	closeButton.connect("pressed",invClose)
	closeButton.disabled = false
func invClose():
	self.visible = false
	closeButton.disabled = true
func invToggle():
	self.visible = !self.visible
	closeButton.disabled = !closeButton.disabled
func _process(delta):
	if(Input.is_action_just_pressed("inventory_toggle")):
		invToggle()

