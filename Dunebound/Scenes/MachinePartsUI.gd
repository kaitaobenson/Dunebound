extends Node2D

const total_machine_parts = 7

@onready var label = $"RichTextLabel"

func _ready():
	pass # Replace with function body.

func _process(delta):
	set_count(7)

func set_count(count: int):
	label.text = "[center]Machine Parts: [b]" + str(count) + "/" + str(total_machine_parts) + "[/b][/center]"
