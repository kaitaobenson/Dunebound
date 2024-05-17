extends Node

@export var area: Area2D
@export var tilemap: TileMap

func _ready():
	tilemap.tile_set.remove_physics_layer(0)
	

func _process(delta):
	if area.get_overlapping_bodies().has(Global.Player):
		tilemap.modulate.a = lerp(tilemap.modulate.a, 0.0, 0.05)
		print("sdfsdf")
	elif tilemap.modulate.a != 1:
		tilemap.modulate.a = lerp(tilemap.modulate.a, 1.0, 0.05)
