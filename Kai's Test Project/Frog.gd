extends CharacterBody2D

var speed = 50
var gravity = 200
var player
var chase
var death

func _ready():
	get_node("AnimatedSprite2D").play("Idle")


func _physics_process(delta):
	#gravity
	velocity.y += gravity * delta 
	
	
	if death != true:
		if(chase == true):
			if get_node("AnimatedSprite2D").animation != "Death":
				get_node("AnimatedSprite2D").play("Jump")
			
			player = get_node("../../Player/Player")
			var direction = (player.position - self.position).normalized()
			velocity.x = direction.x * speed
			if direction.x > 0:
				#right
				get_node("AnimatedSprite2D").flip_h = true
			else:
				#left
				if get_node("AnimatedSprite2D").animation != "Death":
					get_node("AnimatedSprite2D").flip_h = false	
		else:
			if get_node("AnimatedSprite2D").animation != "Death":
				get_node("AnimatedSprite2D").play("Idle")
				velocity.x = 0
		move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_frog_death_body_entered(body):
	if body.name == "Player":
		death = true
		get_node("AnimatedSprite2D").play("Death")
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	
