extends Node2D

@onready var area = $Area2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	if area.get_overlapping_bodies().has(Global.Player):
		print("Sdf")
