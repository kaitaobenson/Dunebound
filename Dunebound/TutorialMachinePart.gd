extends Node2D

func _on_area_2d_body_entered(body):
	if body == Global.Player:
		await Global.fader.fade_in()
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
