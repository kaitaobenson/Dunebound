extends Area2D
func _on_body_entered(body):
	var pos : Vector2 = Vector2(position.x - 45, position.y - 100)
	if body.name == "Player":
		$"../SavingThingy".var_update(pos, "PlayerPos")

