extends Area2D

var tile_types_in_area = []
@export var _health_component: Node

func _ready():
	pass


func _process(delta):
	if tile_types_in_area.has("death"):
		spikes()


### Signals ###

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index) -> void:
	if body is TileMap:
		_process_tilemap_data(body, body_rid, true)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		_process_tilemap_data(body, body_rid, false)


### Takes data and adds/removes tilemap type from array ###

func _process_tilemap_data(body: Node2D, body_rid: RID, is_inside: bool) -> void:
	var current_tilemap = body
	var tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	#0 is tilemap layer
	var tile_data = current_tilemap.get_cell_tile_data(0, tile_coords)
	#0 is first data property element in tilemap
	#var tile_type = tile_data.get_custom_data_by_layer_id(0)
	
	
	#if is_inside && !tile_types_in_area.has(tile_type):
	#	tile_types_in_area.append(tile_type)
	#if !is_inside && tile_types_in_area.has(tile_type):
	#	tile_types_in_area.erase(tile_type)


func spikes():
	var attack = Attack.new()
	attack.attack_damage = 100
	_health_component.damage(attack)
