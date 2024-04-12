extends CharacterBody2D

var velociter : Vector2
var SPEED = 500

func _physics_process(delta):
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	if collision_info != null:
		await get_tree().create_timer(0.1).timeout
		$"../".queue_free()
		queue_free()
