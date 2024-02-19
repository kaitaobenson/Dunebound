extends CharacterBody2D

const swingSpeed:int = 5
#the name of the variable below is a bit of a misnomer, it takes less momentum to swing farther the higher it is
const SWING_GRAVITY:int = 5
var swingPosition:int = 150
var currentMomentumThingy:int = SWING_GRAVITY
var momentum:int
var grappleDownProcessActive:bool = false
var stupidUICloseButtonPressed = false
# Important for camera, don't remove from class level
var direction = 0
#stupid ay stupid ay stupid ahhhhhhhhhhhhhhh
var push_force = 50

@onready var invon = false
@onready var grappleHook = get_node("grappleHook")
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")


var swingCircle:Array
var health:int = 100

func _ready():
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
func _physics_process(delta):
	Global.PlayerX = global_position.x
	Global.PlayerY = global_position.y
	Global.PlayerPosition = global_position
	
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
	direction = Input.get_axis("ui_left", "move-right")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !invon:
		velocity.y = -JUMP_VELOCITY
	# Horiz movement
	if velocity.x == 0:
		anim.stop()
	# Right
	if direction == 1:
		anim.play("Run")
		if invon == false:
			animSprite.flip_h = false
	# Left
	if direction == -1:
		anim.play("Run")
		if invon == false:
			animSprite.flip_h = true
	
	#buetiful code carson copied from stackoverflow
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision && collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * push_force)
	# Grapple Hook
	if (direction == 0 && !grappleDownProcessActive):
		velocity.x = 0
	# Inventory toggle handler
	if(Input.is_action_just_pressed("inventory_toggle")||stupidUICloseButtonPressed):
		if stupidUICloseButtonPressed:
			invon = true
			stupidUICloseButtonPressed = false
		invon = !invon
	# No movement while open inventory
	if invon == false:
		velocity.x = direction * SPEED
		particles(direction)
	else: 
		velocity.x = 0
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
	get_tree().reload_current_scene()
	#whatever you wanna do when you die

func _on_area_2d_body_entered(body):
	if body.name == "mrLegs":
		die()


func particles(direction):
	var particle = $"../SandParticles"
	particle.visible = true
	
	if direction != 0 && is_on_floor():
		particle.emitting = true
		
		# Y + 60 to be at player's feet
		particle.global_position.x = Global.PlayerX
		particle.global_position.y = Global.PlayerY + 60
		
		if direction == 1:
			particle.orbit_velocity_min = 0.1
			particle.orbit_velocity_max = 0.1
			
		if direction == -1:
			particle.orbit_velocity_min = -0.1
			particle.orbit_velocity_max = -0.1
	else:
		particle.emitting = false

func getDirection():
	return direction
