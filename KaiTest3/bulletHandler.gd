extends CharacterBody2D
signal hitByBullet
# Called when the node enters the scene tree for the first time.
func fire(angle,fdamage,speed)->void:
	set_meta("damage",fdamage)
	self.rotation = angle
	velocity.y = sin(angle)
	velocity.x = cos(angle)
	velocity = velocity * speed
func _ready():
	velocity.x = 0
	velocity.y = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move_and_collide(velocity*delta)&&get_meta("bulletActive"):
		var damage = get_meta("damage")
		emit_signal("hitByBullet",damage)
		self.queue_free()
