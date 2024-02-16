extends Node2D

var states = {}

signal particlesOn

func _ready():
	#Add all children to Dictionary
	for child in get_children():
		if child:
			states[child.name.to_lower()] = child
	print(states)

func start_state(name):
	if states.has(name):
		pass
	else:
		print("no")

func stop_state(name):
	if Dictionary(name):
		get_node(name).off()
