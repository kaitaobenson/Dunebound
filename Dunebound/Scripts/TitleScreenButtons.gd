extends GridContainer

@onready var fader = $"../../Fader"

func _on_play_pressed():
	await fader.fade_in()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/Levels/TutorialLevel.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_credits_pressed():
	await fader.fade_in()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
