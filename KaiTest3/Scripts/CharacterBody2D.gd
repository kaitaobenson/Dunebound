extends CharacterBody2D

const SPEED_LIMIT  = 300.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 500;
const swingSpeed:int = 5
#the name of the variable below is a bit of a misnomer, it takes less momentum to swing farther the higher it is
const SWING_GRAVITY:int = 5
var swingPosition:int = 150
var currentMomentumThingy:int = SWING_GRAVITY
var momentum:int
@onready var grappleHook = get_node("grappleHook")
var grappleDownProcessActive:bool = false
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")
var swingCircle:Array
var health:int = 100;

func ready():
	pass;
	
# WALK
func _physics_process(delta):
	if(is_on_floor()):
		self.rotation = 0
	if(grappleDownProcessActive):
		grappleHook.rope.set_point_position(0,self.position)
		self.rotation = (self.position - grappleHook.hook.position).normalized().angle()
		if(self.position<grappleHook.hook.position):
			self.velocity = -Vector2(cos(self.rotation),sin(self.rotation))*delta*grappleHook.get_meta("hookSpeed")
		elif(self.position>grappleHook.hook.position):
			self.velocity = Vector2(cos(self.rotation),sin(self.rotation))*delta*grappleHook.get_meta("hookSpeed")
		var swingDirection = Input.get_axis("ui_left", "move-right")
		swingCircle = grappleHook.swingPathGenerator(grappleHook.grappleTargetLocation,self.position)
		
		if(swingPosition+momentum>currentMomentumThingy||swingPosition+momentum<-abs(currentMomentumThingy)):
			swingDirection = -swingDirection
			momentum += swingDirection*swingSpeed
			currentMomentumThingy *= SWING_GRAVITY
			swingPosition+=momentum
			print("somethingHappened")
		self.position = swingCircle[swingPosition]
		print(swingCircle[swingPosition])
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
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "move-right")
	
	#horiz movement
	if velocity.x == 0:
		anim.stop()
	
	if direction == 1:
		anim.play("Walk")
		animSprite.flip_h = false
		
	velocity.x = direction * SPEED
	if direction == -1:
		anim.play("Walk")
		animSprite.flip_h = true
		if(velocity.x+direction*SPEED>SPEED_LIMIT):
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
