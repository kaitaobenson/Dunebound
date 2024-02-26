extends CharacterBody2D
var playerinside = false
var TimeSinceHit = 0
var direction
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if abs(Global.PlayerX - position.x) < 1:
		direction = 0
	elif Global.PlayerX < position.x:
		direction = -1
	elif Global.PlayerX > position.x:
		direction = 1
	
	TimeSinceHit += delta
	if (playerinside && TimeSinceHit > .5):
		TimeSinceHit = 0
		Global.Player.take_damage(20, self)
	
	velocity.x = direction * SPEED
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		playerinside = true
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		playerinside = false
