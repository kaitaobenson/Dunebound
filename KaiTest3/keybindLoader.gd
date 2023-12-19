extends Node


@onready var actions:Array = []
var Parse:JSON = JSON.new()

func addInputAction(key:String,actionName:String):
	var donger = OS.find_keycode_from_string(key)
	var dingdongdingalongadingdongdee:InputEventKey = InputEventKey.new()
	dingdongdingalongadingdongdee.physical_keycode = donger
	InputMap.add_action(actionName)
	InputMap.action_add_event(actionName,dingdongdingalongadingdongdee)
  
func Unparse():
	pass
	
func changeKeybind(actionName:String,newKey:String)->bool:
	var bufferParse:JSON = JSON.new()
	var lerawjson = FileAccess.open("res://userData/keybinds.json",FileAccess.READ)
	var lejson = lerawjson.get_as_text()
	bufferParse.parse(lejson)
	
	var leJsonBuffer = bufferParse.data
	lerawjson.close()
	
	var foundActionNumber = -1
	for bhhbj in leJsonBuffer["keybinds"].size():
		if(leJsonBuffer["keybinds"][bhhbj]["actionName"]==actionName):
			foundActionNumber = bhhbj
			break
			
	if(foundActionNumber == -1):
		return false
		
	leJsonBuffer["keybinds"][foundActionNumber]["key"] = newKey
	lerawjson = FileAccess.open("res://userData/keybinds.json",FileAccess.WRITE)
	lerawjson.store_string(bufferParse.stringify(leJsonBuffer,"\t"))
	lerawjson.close()
	
	return true
func reloadKeybinds():
	var keybindConfig = FileAccess.open("res://userData/keybinds.json",FileAccess.READ)
	var configText = keybindConfig.get_as_text()
	actions = InputMap.get_actions()
	
	for d in actions.size():
		InputMap.erase_action(actions[d])
		
	Parse.parse(configText)
	var parseData = Parse.data
	for ygu in parseData["keybinds"].size():
		addInputAction(parseData["keybinds"][ygu]["key"],parseData["keybinds"][ygu]["actionName"])
		
	keybindConfig.close()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	reloadKeybinds()
