extends Node2D
@onready var uiContainer = get_parent().get_node("uiContainer")
func _process(delta):
	if Input.is_action_just_pressed("openKeybindUI"):
		if(uiContainer.visible):
			uiContainer.visible = false
		else:
			uiContainer.visible = true
