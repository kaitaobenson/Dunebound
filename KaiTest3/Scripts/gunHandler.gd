extends Sprite2D
var fireActive:bool = false
@onready var timer = get_node("shootTimer")
@onready var reloadTimer = get_node("reloadTimer")
var ammo:int
func _ready():
	#all timers in seconds (not milliseconds)
	ammo = self.get_meta("bulletPerClip")
	timer.wait_time = self.get_meta("shotSpeed")
	print(timer.wait_time)
	reloadTimer.wait_time = self.get_meta("reloadTime")
	timer.connect("timeout",fireBullet)
	timer.start()
func fireBullet()->void:
	print(ammo)
	if ammo>0:
		ammo -= 1
		var newBullet = get_node("masterBullet").duplicate()
		newBullet.set_meta("bulletActive",true)
		get_tree().get_current_scene().add_child(newBullet)
		newBullet.position = position 

		newBullet.fire(self.rotation,get_meta("damage"),get_meta("bulletSpeed"))
	else:
		timer.stop()
		#reload sequence here
		reloadTimer.start()
		await reloadTimer.timeout
		ammo += get_meta("bulletPerClip")
		timer.start()
func _process(delta):
	rotation_degrees += 1
