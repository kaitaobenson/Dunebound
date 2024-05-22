extends Area2D
var disable = false


func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		disable = true

func get_damage_id():
	if !disable:
		return "CloseRangeExplosion"
	else:
		return "null"
