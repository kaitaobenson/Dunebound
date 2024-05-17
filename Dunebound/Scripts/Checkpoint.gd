extends Area2D

func _on_body_entered(body):
	var pos : Vector2 = global_position
	if body.name == "Player" && !Global.Player.is_dead:
		Global.saver_loader.var_update(pos, "RespawnPos")

func get_damage_id():
	return "Checkpoint"
