extends Node2D

@export var area_node: Area2D

var player_is_inside_area: bool = false
var has_shown_label: bool = false
var can_show: bool = true

var fade_in
var fade_out

@onready var timer = get_tree().create_timer(5)
@onready var text = $"CanvasLayer/RichTextLabel"
@onready var canvas_layer = $"CanvasLayer"

func _ready():
	fade_in = get_tree().create_tween()
	fade_out = get_tree().create_tween()
	
	canvas_layer.visible = true
	text.modulate.a = 0


func _process(delta):
	if area_node.body_entered:
		if area_node.get_overlapping_bodies().has(Global.Player):
			player_is_inside_area = true
		else:
			player_is_inside_area = false
	
	
	if has_shown_label && timer.time_left == 0:
		do_fade_out()
	if !has_shown_label:
		timer = get_tree().create_timer(5)
	if !has_shown_label == true && can_show == false:
		if !player_is_inside_area:
			can_show = true
	
	if (player_is_inside_area) && (!has_shown_label) && (can_show):
		do_fade_in()
	if (!player_is_inside_area) && (has_shown_label):
		can_show = true
		do_fade_out()


func do_fade_in():
	can_show = false
	has_shown_label = true
	fade_out.stop()
	
	fade_in = get_tree().create_tween()
	fade_in.tween_property(text, "modulate:a", 1, 5)


func do_fade_out():
	has_shown_label = false
	fade_in.stop()
	
	fade_out = get_tree().create_tween()
	fade_out.tween_property(text, "modulate:a", 0, 2)
