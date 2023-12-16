extends Node

func addInputAction(key:String,actionName:String):
	var donger = OS.find_keycode_from_string(key)
	var dingdongdingalongadingdongdee:InputEventKey = InputEventKey.new()
	dingdongdingalongadingdongdee.physical_keycode = donger
	InputMap.add_action(actionName)
	InputMap.action_add_event(actionName,dingdongdingalongadingdongdee)
@onready var actions:Array = []
var Parse:JSON = JSON.new()
#unparse is totally super useful, despite the fact that it doesnt do anything (source: trust me bro)
#i am the big smart lead programmer
#so you cannot doubt me
#ahahahahaha
var Unparse
func reloadKeybinds():
	var keybindConfig = FileAccess.open("res://userData/keybinds.json",FileAccess.READ)
	actions = InputMap.get_actions()
	for d in actions.size():
		InputMap.erase_action(actions[d])
	Parse.parse(keybindConfig)
	for ygu in Parse["keybinds"].size():
		addInputAction(Parse["keybinds"][ygu]["key"],Parse["keybinds"][ygu]["actionName"])

# Called when the node enters the scene tree for the first time.
func _ready():
	reloadKeybinds()
