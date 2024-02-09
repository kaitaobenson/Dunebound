extends ColorRect
#this script handles unpausing
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		print("womp")
		get_tree().paused = !get_tree().paused
		get_parent().visible = !get_parent().visible
