extends Node2D
@onready var masterBullet = get_node("masterBullet")
@onready var timePerShotIncrementer:float
@onready var shotsFired:int
@onready var reloadTimeCounter:float
@onready var currentScene
#all time based gun metadata in seconds
func fireBullet():
	var bulletClone = masterBullet.duplicate(15)
	#bulletClone.visible = true
	#bulletClone.set_meta("bulletActive",true)
	currentScene.add_child(bulletClone)
	bulletClone.position = self.position
	bulletClone.fire(self.rotation,get_meta("Damage"),get_meta("bulletSpeed"))
# Called when the node enters the scene tree for the first time.
func _ready():
	currentScene = get_tree().get_current_scene()
func _physics_process(delta):
	print("ahhhhhhhh godot code make me insane")
	print(timePerShotIncrementer)
	print(timePerShotIncrementer>=self.get_meta("shotSpeed"))
	timePerShotIncrementer += delta/2
	if(shotsFired>=self.get_meta("clipSize")):
		print("shit")
		if(shotsFired==self.get_meta("clipSize")):
			reloadTimeCounter = 0
			shotsFired += 1
		reloadTimeCounter += delta
		if(reloadTimeCounter<self.get_meta("reloadTime")):
			return
		shotsFired = 0
	elif(timePerShotIncrementer>=self.get_meta("shotSpeed")):
		for x in self.get_meta("shotSpeed")/timePerShotIncrementer:
			fireBullet()
		shotsFired += 1
		timePerShotIncrementer = 0
