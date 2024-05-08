extends Node2D


func _ready():
	await get_tree().process_frame
	Global.fader.set_modulate_a(1)
	Global.fader.fade_out()
