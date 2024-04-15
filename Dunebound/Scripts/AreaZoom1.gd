extends Node2D

@export var go_to_zoom_value: float = 1
@export var go_to_time_value: float = 5
@export var back_from_time_value: float = 5

@export var area_node: Area2D

var player_is_inside_area: bool = false
var has_shown_label: bool = false

var fade_in: Tween
var fade_out: Tween
var zoom: float
var begin_zoom: float


func _ready():
	zoom = Global.camera.zoom.x
	begin_zoom = Global.camera.zoom.x
	
	fade_in = get_tree().create_tween()
	fade_out = get_tree().create_tween()


func _process(delta):
	Global.camera.set_zoom(Vector2(zoom, zoom))
	if area_node.body_entered:
		if area_node.get_overlapping_bodies().has(Global.Player):
			player_is_inside_area = true
		else:
			player_is_inside_area = false
	
	
	if (player_is_inside_area) && (!has_shown_label):
		do_fade_in()
	if (!player_is_inside_area) && (has_shown_label):
		do_fade_out()


func do_fade_in():
	has_shown_label = true
	fade_out.stop()
	
	fade_in = get_tree().create_tween()
	fade_in.tween_property(self, "zoom", go_to_zoom_value, go_to_time_value)


func do_fade_out():
	has_shown_label = false
	fade_in.stop()
	
	fade_out = get_tree().create_tween()
	fade_out.tween_property(self, "zoom", begin_zoom, back_from_time_value)
