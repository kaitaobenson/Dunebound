extends CanvasLayer

@onready var container = $"Container"
@onready var play_again: Button = $"Container/PlayAgain"
@onready var quit: Button = $"Container/Quit"

var fade_time = 1

func _init():
	Global.death_ui = self
	visible = false

func turn_on():
	container.modulate.a = 0
	visible = true
	get_tree().create_tween().tween_property(container, "modulate:a", 1, fade_time)
	
func turn_off():
	visible = false

func is_play_again_pressed():
	return play_again.is_pressed()
func is_quit_pressed():
	return quit.is_pressed()
