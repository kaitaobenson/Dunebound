extends Node
@onready var kids = {}
#ello! this node is for duplicating objects that will be used alot, and this script handles that duplication.
func _ready():
	#iterate through all the children of this node (the library) and add them to a dictionary with name and path
	for i in self.get_children():
		kids[i.name] = i.get_path()
func takeObject(nem):
	#15 is the default arg value for duplicate that tells it to duplicate EVERYHING in whatever object is passed to it
	return get_node(kids[nem]).duplicate(15)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
