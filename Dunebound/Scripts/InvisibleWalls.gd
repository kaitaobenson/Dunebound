extends Node

@export var area: Area2D
@export var sprite: Node

func _process(delta):
	for x in range(sprite.get_used_rect().size.x):
		for y in range(sprite.get_used_rect().size.y):
			# Get the tile ID at this position
			var tile_id = sprite.get_cell(x, y)
			
			# Check if the tile is valid and has collision
			if tile_id != -1 and sprite.tile_set.tile_get_collision(tile_id) != 0:
				# Disable collision for this tile
				sprite.tile_set.tile_set_collision(tile_id, false)
				
	
	if area.get_overlapping_bodies().has(Global.Player):
		sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 0.05)
		print("sdfsdf")
	elif sprite.modulate.a != 1:
		sprite.modulate.a = lerp(sprite.modulate.a, 1.0, 0.05)
