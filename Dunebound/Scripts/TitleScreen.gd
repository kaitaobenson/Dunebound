extends Node2D

@export var do_display: bool = true

@onready var logo = $"Logo"
@onready var title_screen = $"MainScreen"
@onready var fader = $"Fader"

var displayed_logo: bool = false
var displayed_title_screen: bool = false

var logo_display_time: float = 1
var fade_time: float = 2


func _ready():
	fader.set_modulate_a(1)
	fader.fade_out()
	
	if do_display:
		logo.visible = true
		logo.modulate.a = 0
		title_screen.visible = false
		
		get_tree().create_tween().tween_property(logo, "modulate:a", 1, fade_time)
		await get_tree().create_timer(logo_display_time).timeout
		get_tree().create_tween().tween_property(logo, "modulate:a", 0, fade_time)
		await get_tree().create_timer(1).timeout
		
		logo.free()
		title_screen.modulate.a = 0
		title_screen.visible = true
		get_tree().create_tween().tween_property(title_screen, "modulate:a", 1, fade_time)
		
	else:
		Global.root_node.change_level_to_scene("res://Scenes/Levels/WORLD.tscn")
