extends TextureButton
@onready var thingy = get_parent().get_node("mrLegs/Camera2D/Control/inventoryContainer/itemTileContainer/"+get_meta("tileName"))
func _process(delta):
	self.position = thingy.global_position
	var local_mouse_pos = get_global_mouse_position()
	var hovering = Rect2(self.position, thingy.size).has_point(local_mouse_pos)
	print(local_mouse_pos)
	print(self.position)
	if(hovering):
		print("hover go brrrr")
		thingy.color = Color("333333")
	else:
		thingy.color = Color("4b4b4b")
