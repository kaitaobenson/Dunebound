extends Node2D

var total_machine_parts = 0

var machine_part_count = 0
@onready var label = $"RichTextLabel"

func _process(delta):
	var count = Global.collected_machine_parts
	var total_machine_parts = Global.total_machine_parts
	label.text = "[center]Machine Parts: [b]" + str(count) + "/" + str(total_machine_parts) + "[/b][/center]"
