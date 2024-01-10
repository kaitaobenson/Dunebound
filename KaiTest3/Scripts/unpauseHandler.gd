extends ColorRect
#this script handles unpausing
func pause():
	await get_tree().process_frame
	get_tree().paused = true
	get_parent().visible = true
func _process(delta):
	if (Input.is_action_just_pressed("pause_toggle")):
		get_tree().paused = false
		get_parent().visible = false
func resize():
	self.size = get_viewport().get_visible_rect().size
func _ready():
	get_tree().get_root().size_changed.connect(resize)
	resize()
