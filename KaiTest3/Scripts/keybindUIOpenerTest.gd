extends Node2D
@onready var uiContainer = get_parent().get_node("uiContainer")
func toggleOpen():
		if(uiContainer.visible):
			uiContainer.visible = false
			get_tree().paused = false
		else:
			uiContainer.visible = true
			get_tree().paused = true
func _process(delta):
	if Input.is_action_just_pressed("openKeybindUI"):
		toggleOpen()
