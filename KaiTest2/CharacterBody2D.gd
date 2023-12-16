extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var speed = 100;
	var gravity = 100;
	var jumpForce = 150;
	
	velocity.y += gravity * delta;
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed * delta
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x += -speed * delta
		
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -jumpForce
	move_and_slide()
	
	
