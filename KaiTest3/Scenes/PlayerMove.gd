extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_direction = Input.get_axis("move_left", "move_right")
	ad_movement(player_direction)
	
func ad_movement(direction : int):
	if direction != 0:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, true)
	else:
		_anim_manager.change_animation(ALL_ANIMATIONS.RUN, false)
		velocity.x = 0
	
	if direction > 0:
		flip(true)
	elif direction < 0:
		flip(false)
	velocity.x = direction * player_speed
	
	
	move_and_slide()
