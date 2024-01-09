extends CharacterBody2D

const SPEED_LIMIT  = 300.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 500;
@onready var grappleHook = get_node("grappleHook")
var grappleDownProcessActive:bool = false
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")
var grappleRopeLength:int
var health:int = 100;
func grappleSwingSpeedLimitHandler(direction:int)->int:
	if(grappleHook.rope!=null):
		var oobagooba = grappleHook.rope.get_point_position(1)
		oobagooba.x += velocity.x
		if(grappleDownProcessActive&&(oobagooba).distance_to(self.position)>grappleRopeLength):
			return 0 
			print("ah shit")
		else:
			return SPEED_LIMIT
	else:
		return SPEED_LIMIT
func ready():
	pass;
	
# WALK
func _physics_process(delta):
	if(is_on_floor()):
		self.rotation = 0
	if(grappleDownProcessActive):
		grappleHook.rope.set_point_position(0,self.position)
		self.rotation = (self.position - grappleHook.hook.position).normalized().angle() + PI
		if(self.position<grappleHook.hook.position):
			self.velocity = -(self.position - grappleHook.hook.position).normalized()*delta*grappleHook.get_meta("hookSpeed")
		elif(self.position>grappleHook.hook.position):
			self.velocity = (grappleHook.hook.position-self.position).normalized()*delta*grappleHook.get_meta("hookSpeed")
		print(self.velocity)
		var sillygoofy = move_and_collide(self.velocity)
		if(sillygoofy!=null):
			if(sillygoofy.get_collider()==grappleHook.hook):
				self.rotation = 0
				grappleHook.rope.queue_free()
				grappleHook.hook.queue_free()
				grappleHook.activeGrappleShooting = false
				grappleHook.activeGrappleGoUp = false
				grappleHook.mousePressed = false
				grappleDownProcessActive = false
		grappleRopeLength = grappleHook.getRopeLength()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "move-right")
	var thingya = grappleSwingSpeedLimitHandler(direction)
	#horiz movement
	if velocity.x == 0:
		anim.stop()
	
	if direction == 1:
		anim.play("Walk")
		animSprite.flip_h = false
		if(velocity.x+direction*SPEED<=thingya&&velocity.x+direction*SPEED>=-thingya):
			velocity.x += direction * SPEED
	#velocity.x = direction * SPEED
	if direction == -1:
		anim.play("Walk")
		animSprite.flip_h = true
		print(velocity.x+direction*SPEED)
		if(velocity.x+direction*SPEED<=thingya&&velocity.x+direction*SPEED>=-thingya):
			velocity.x += direction * SPEED
	if (direction == 0&&!grappleDownProcessActive):
		velocity.x = 0

	move_and_slide()
func grappleDown():
	grappleDownProcessActive = true
func _hitByBullet(damage:int):
	print("hit by bullet")
	doDamage(damage)
func amPlayer():
	pass
func noGrapple():
	pass
func doDamage(damage:int):
	health = health - damage
	print(health)
	if(health<=0):
		die()
func die():
	self.queue_free()
	#whatever you wanna do when you die
