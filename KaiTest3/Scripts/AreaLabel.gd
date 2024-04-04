extends Node2D

var player_is_inside_area: bool = false
var has_shown_label: bool = false
var can_show: bool = true

var fade_in
var fade_out

@onready var timer = get_tree().create_timer(5)

@onready var text = $"CanvasLayer/RichTextLabel"

func _ready():
	fade_in = get_tree().create_tween()
	fade_out = get_tree().create_tween()
	
	text.modulate.a = 0

func _process(delta):
	if has_shown_label && timer.time_left == 0:
		do_fade_out()
	if !has_shown_label:
		timer = get_tree().create_timer(5)
	if !has_shown_label == true && can_show == false:
		if !player_is_inside_area:
			can_show = true
	
	if (player_is_inside_area) && (!has_shown_label) && (can_show):
		print("fadingin")
		do_fade_in()
	if (!player_is_inside_area) && (has_shown_label):
		can_show = true
		print("fadingout")
		do_fade_out()


func do_fade_in():
	can_show = false
	has_shown_label = true
	fade_out.stop()
	
	fade_in = get_tree().create_tween()
	fade_in.tween_property(text, "modulate:a", 1, 5)

func do_fade_out():
	has_shown_label = false
	#print("faing outt!!!!")
	fade_in.stop()
	
	fade_out = get_tree().create_tween()
	fade_out.tween_property(text, "modulate:a", 0, 2)


func _on_area_2d_body_entered(body):
	if body == Global.Player:
		player_is_inside_area = true

func _on_area_2d_body_exited(body):
	if body == Global.Player:
		player_is_inside_area = false
