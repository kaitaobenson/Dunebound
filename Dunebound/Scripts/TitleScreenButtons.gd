extends GridContainer

@onready var fader = $"../../Fader"

@onready var tutorial = $"Tutorial"
@onready var play = $"Play"
@onready var credits = $"Credits"


func _process(delta):
	if tutorial.is_pressed():
		_on_tutorial_pressed()
	if play.is_pressed():
		_on_play_pressed()
	if credits.is_pressed():
		_on_credits_pressed()


func _on_tutorial_pressed():
	await fader.fade_in()
	Global.root_node.change_level_to_scene("res://Scenes/Levels/TutorialLevel.tscn")

func _on_play_pressed():
	await fader.fade_in()
	Global.root_node.change_level_to_scene("res://Scenes/Levels/WORLD.tscn")

func _on_credits_pressed():
	await fader.fade_in()
	Global.root_node.change_level_to_scene("res://Scenes/Credits.tscn")
