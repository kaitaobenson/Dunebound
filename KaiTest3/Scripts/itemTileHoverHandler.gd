extends TextureButton

@onready var thingy = get_tree().get_root().get_node("Node2D/Camera2D/Control/inventoryContainer/itemTileContainer/itemTileTemplate")
func _process(delta):
	self.position = thingy.global_position
	var local_mouse_pos = get_global_mouse_position()
	var hovering = Rect2(self.position, thingy.size).has_point(local_mouse_pos)
	if(hovering):
		thingy.color = Color("333333")
	else:
		thingy.color = Color("4b4b4b")
