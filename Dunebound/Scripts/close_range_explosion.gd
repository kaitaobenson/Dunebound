extends Area2D



func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		set_deferred("monitorable", false)

func get_damage_id():
	return "CloseRangeExplosion"
