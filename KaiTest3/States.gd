extends Node

var states = {}

func _ready():
	#Add all children to Dictionary
	for child in get_children():
		states[child.name.to_lower()] = child

func set_state_status(childName:String, isOn):
	if states.has(childName.to_lower()):
		states[childName.to_lower()].isOn = isOn

func get_state_status(childName:String):
	if states.has(childName.to_lower()):
		return states[childName].isOn

func get_state(childName:String):
	if states.has(childName.to_lower()):
		return states[childName.to_lower()]
