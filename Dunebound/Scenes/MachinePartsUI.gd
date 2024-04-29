extends Node2D

const total_machine_parts = 7

var machine_part_count = 0
@onready var label = $"RichTextLabel"

func _ready():
	set_count(machine_part_count)

func set_count(count: int):
	machine_part_count = count
	label.text = "[center]Machine Parts: [b]" + str(count) + "/" + str(total_machine_parts) + "[/b][/center]"

func get_count() -> int:
	return machine_part_count
