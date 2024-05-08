extends Area2D

func _physics_process(delta):
	if get_overlapping_bodies().has(Global.Player):
		await get_tree().create_timer(0.01).timeout
		$"../".queue_free()


func get_damage_id():
	return "Healer"
