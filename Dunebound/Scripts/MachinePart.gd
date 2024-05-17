extends Node2D

@onready var area = $Area2D

var has_been_collected: bool = false

func _ready():
	pass # Replace with function body.


func _process(delta):
	if area.get_overlapping_bodies().has(Global.Player):
		if !has_been_collected:
			has_been_collected = true
			Global.collected_machine_parts += 1
			Global.saver_loader.var_update(Global.collected_machine_parts, "CollectedMachineParts")
			Global.saver_loader.var_update(get_path(), "KillList")
			
			queue_free()
