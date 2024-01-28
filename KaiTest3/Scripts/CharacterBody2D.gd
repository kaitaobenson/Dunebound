extends CharacterBody2D

const swingSpeed:int = 5
#the name of the variable below is a bit of a misnomer, it takes less momentum to swing farther the higher it is
const SWING_GRAVITY:int = 5
var swingPosition:int = 150
var currentMomentumThingy:int = SWING_GRAVITY
var momentum:int
var grappleDownProcessActive:bool = false

@onready var invopen = get_node("Camera2D").get_node("Control").get_node("inventoryContainer").invopen
@onready var grappleHook = get_node("grappleHook")
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")
var swingCircle:Array
var health:int = 100;

func ready():
	pass;
	

func _physics_process(delta):
	Global.PlayerX = self.position.x
	print(Global.PlayerX)
	Global.PlayerY = self.position.x
	movement(delta)
	grapple(delta)
	
func grapple(delta):
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
		self.position = swingCircle[swingPosition]
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

func movement(delta):
	
	var SPEED = get_meta("SPEED")
	var JUMP_VELOCITY = get_meta("JUMP")
	var gravity = get_meta("GRAVITY");
	var direction = Input.get_axis("ui_left", "move-right")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	# Horiz movement
	if velocity.x == 0:
		anim.stop()
	# Right
	if direction == 1:
		anim.play("Walk")
		animSprite.flip_h = false
	# Left
	if direction == -1:
		anim.play("Walk")
		animSprite.flip_h = true
	# Grapple Hook
	if (direction == 0&&!grappleDownProcessActive):
		velocity.x = 0
	# No movement while open inventory
	if invopen == false:
		velocity.x=0
	print (invopen)
	velocity.x = direction * SPEED
	move_and_slide()

func grappleDown():
	grappleDownProcessActive = true
func _hitByBullet(damage:int):
	doDamage(damage)
func amPlayer():
	pass
func noGrapple():
	pass
func doDamage(damage:int):
	health = health - damage
	if(health<=0):
		die()
func die():
	self.queue_free()
	#whatever you wanna do when you die
