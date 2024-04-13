extends GridContainer

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
