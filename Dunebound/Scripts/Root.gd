extends Node2D

func _init():
	Global.root_node = self


func _ready():
	change_level_to_scene("res://Scenes/Levels/TitleScreen.tscn")
	

func _process(delta):
	pass


func change_level_to_scene(path: String):
	for child in get_children():
		if child != Global.saver_loader:
			child.queue_free()
			await child.tree_exited
	
	await get_tree().create_timer(1).timeout
	add_child(load(path).instantiate())
	Global.current_scene_path = path
	
	kill_list()


func kill_list():
	for item_to_kill in Global.saver_loader.save_dict["KillList"]:
		if get_node_or_null(item_to_kill) != null:
			get_node(item_to_kill).queue_free()

