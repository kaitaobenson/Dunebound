extends Node2D

#Whatever you want to do at the beginning ig?

func _ready():
	await get_tree().process_frame
	Global.fader.set_modulate_a(1)
	Global.fader.fade_out()

func _process(delta):
	#WIN
	if Global.collected_machine_parts == Global.total_machine_parts:
		Global.fader.fade_in_time = 1
		await Global.fader.fade_in()    
		Global.root_node.change_level_to_scene("res://Scenes/Levels/WinScreen.tscn")

