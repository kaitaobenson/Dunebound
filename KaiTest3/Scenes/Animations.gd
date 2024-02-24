extends Node

var current_animations = ["IDLE"]
@onready var _anim = %Player/AnimationPlayer

func set_animation_status(name:String, isOn:bool):
	if isOn:
		if current_animations.has(name) == false:
			current_animations.append(name)
	else:
		if current_animations.has(name) == true:
			current_animations.erase(name)

func _process(delta):
	if current_animations.has("ATTACK"):
		animation("ATTACK")
	elif current_animations.has("RUN"):
		animation("RUN")
	elif current_animations.has("IDLE"):
		animation("IDLE")

var currentAnimation
func animation(animationName):
	
	#RUN
	if animationName == "RUN" && currentAnimation != "RUN":
		if currentAnimation != "RUN":
			_anim.stop()
		_anim.play("Run")
		currentAnimation = "RUN"
		
	#ATTACK
	if animationName == "ATTACK" && currentAnimation != "ATTACK":
		if currentAnimation != "ATTACK":
			_anim.stop() 
		_anim.play("Slash1")
		currentAnimation = "ATTACK"
		
	#IDLE
	if animationName == "IDLE" && currentAnimation != "IDLE":
		if currentAnimation != "IDLE":
			_anim.stop()
		
		_anim.play("Idle")
		currentAnimation = "IDLE"
