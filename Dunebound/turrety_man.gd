extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Player = Global.Player
@onready var line_of_sight = $"LineOfSightPivot/LineOfSight" as RayCast2D
@onready var line_of_sight_pivot = $"LineOfSightPivot" as Node2D
var can_see : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func is_in_range():
	var who_i_see = $"LineOfSightPivot/LineOfSight".get_collider()
	var can_i_see = $"LineOfSightPivot/LineOfSight".is_colliding()
	if who_i_see == Player:
		can_see = true
	else:
		await get_tree().create_timer(0.25).timeout
		if who_i_see == Player:
			can_see = true
		else:
			can_see = false

func raycast_direction():
	var direction_to_player : Vector2 = Vector2(Global.Player.global_position.x, Global.Player.global_position.y - 8) - line_of_sight.position
	line_of_sight_pivot.look_at(direction_to_player)
