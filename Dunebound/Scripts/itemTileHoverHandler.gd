extends ColorRect

@onready var thingy = get_tree().get_root().get_node("WORLD/Stuff/NecessaryStuff/UI/inventoryContainer/itemTileContainer/itemTileTemplate")
func _process(delta):
	var local_mouse_pos = get_global_mouse_position()
	var hovering = Rect2(self.global_position, self.size).has_point(local_mouse_pos)
	if(hovering):
		self.color = Color("333333")
	else:
		self.color = Color("4b4b4b")
