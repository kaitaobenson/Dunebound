extends Node2D

@onready var credits_text = $"Credits"
@onready var decor = $"Decorations"
@onready var sensor = $"Sensor"
@onready var fader = $"Fader"

func _ready():
	pass # Replace with function body.

func _process(delta):
	credits_text.position.y -= 1
	sensor.position.y -= 1
	decor.position.y -= 1
	
	if sensor.position.y == 0:
		fader.fade_in()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
		
