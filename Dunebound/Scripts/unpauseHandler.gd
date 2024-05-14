extends ColorRect
var save
var controls
#this script handles unpausing
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		print("game paused")
		print(get_tree().paused)
		get_parent().visible = !get_parent().visible
		get_parent().get_parent().get_parent().get_node("stupidScrollbarBullshitWhyDOesGodotNeedToBeLikeThis/VScrollBar").visible = false
		get_parent().get_parent().get_parent().get_node("proFix/uiContainer").visible = false
		
#handle the buttons in the pause menu through script, because i dont feel like finding whats blocking them
func _ready():
	controls = get_parent().get_node("Button")
	save = get_parent().get_node("Button2")
	#get.tree().paused
func isHovering(size,pos):
	return Rect2(pos, size).has_point(get_global_mouse_position())
func _input(event):
	if ((event is InputEventMouseButton and event.button_index==1) or event is InputEventMouseMotion):
		var pressed = event is InputEventMouseButton and event.button_index==1 and event.is_pressed()
		if(isHovering(controls.size,controls.global_position)):
			controls.color = Color("333333")
			if(pressed):
				get_parent().get_parent().get_parent().get_node("stupidScrollbarBullshitWhyDOesGodotNeedToBeLikeThis/VScrollBar").visible = !get_parent().get_parent().get_parent().get_node("stupidScrollbarBullshitWhyDOesGodotNeedToBeLikeThis/VScrollBar").visible
				get_parent().get_parent().get_parent().get_node("proFix/uiContainer").visible = !get_parent().get_parent().get_parent().get_node("proFix/uiContainer").visible
		else:
			controls.color = Color("4b4b4b")
		if(isHovering(save.size,save.global_position)):
			save.color = Color("333333")
			if(pressed):
				pass
				#todo: make save game menu
		else: 
			save.color = Color("4b4b4b")
	
