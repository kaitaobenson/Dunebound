extends Node2D

var player_is_inside_area: bool = false
var has_shown_label: bool = false

@onready var text = $"CanvasLayer/RichTextLabel"

func _ready():
	text.modulate.a = 0

func _process(delta):
	if (player_is_inside_area) && (!has_shown_label):
		print("1")
		has_shown_label = true
		await get_tree().create_tween().tween_property(text, "modulate:a", 1, 9)
		
	if (!player_is_inside_area) && (has_shown_label):
		print("2")
		has_shown_label = false
		await get_tree().create_tween().tween_property(text, "modulate:a", 0, 4)

func _on_area_2d_body_entered(body):
	if body == Global.Player:
		player_is_inside_area = true

func _on_area_2d_body_exited(body):
	if body == Global.Player:
		player_is_inside_area = false
