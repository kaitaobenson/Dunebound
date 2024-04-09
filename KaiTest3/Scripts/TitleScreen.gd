extends Node2D

@onready var logo = $"Logo"

var displayed_logo: bool = false
var logo_display_time: float = 5
var logo_fade_time: float = 1


func _ready():
	logo.modulate.a = 0


func _process(delta):
	
	if !displayed_logo:
		displayed_logo = true
		print("sdsdf")
		var tween1 = Tween.new()
		tween1.tween_property(logo, "modulate:a", 100, 0)
		#await get_tree().create_timer(logo_display_time).timeout
		#Tween.new().tween_property(logo, "modulate:a", 0, logo_fade_time)
