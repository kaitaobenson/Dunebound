extends Node2D

func _init():
	Global.root_node = self


func _ready():
	change_level_to_scene("res://Scenes/TitleScreen.tscn")
	pass

func _process(delta):
	pass


func change_level_to_scene(path: String):
	for children in get_children():
		children.queue_free()
	add_child(load(path).instantiate())
