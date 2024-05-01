extends Node2D

@onready var area = $Area2D
@onready var machine_part_ui = Global.kai_ui_container.get_node("MachineParts")

var has_been_collected: bool = false

func _ready():
	pass # Replace with function body.


func _process(delta):
	if area.get_overlapping_bodies().has(Global.Player):
		if !has_been_collected:
			has_been_collected = true
			machine_part_ui.set_count(machine_part_ui.get_count() + 1)
		
