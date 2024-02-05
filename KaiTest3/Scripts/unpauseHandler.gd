extends ColorRect
#this script handles unpausing
func pause():
	await get_tree().process_frame
	get_tree().paused = true
	get_parent().visible = true
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		get_parent().visible = !get_parent().visible
