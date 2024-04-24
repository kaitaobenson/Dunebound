extends Node


@onready var actions:Array = []
var Parse:JSON = JSON.new()
func makeDefaultKeybinds()->void:
	#uncomment the line below and delete the line below that line once its time to deploy to production
	#also do the same in line 55 of UIGenerator.gd
	#if(!FileAccess.file_exists("user://keybinds.json")):
	if(true):
		var parse:JSON = JSON.new()
		var defaultkeybinds = FileAccess.open("res://userData/keybinds.json",FileAccess.READ)
		var userKeybindFile = FileAccess.open("user://keybinds.json",FileAccess.WRITE)
		userKeybindFile.store_string(defaultkeybinds.get_as_text())
		userKeybindFile.close()
func addInputAction(key:String,actionName:String):
	var donger = OS.find_keycode_from_string(key)
	var dingdongdingalongadingdongdee:InputEventKey = InputEventKey.new()
	dingdongdingalongadingdongdee.physical_keycode = donger
	InputMap.add_action(actionName)
	InputMap.action_add_event(actionName,dingdongdingalongadingdongdee)
  
func Unparse():
	pass
func changeKeybind(actionName:String,keybindNumber:int,newKey:String)->bool:
	var bufferParse:JSON = JSON.new()
	var lerawjson = FileAccess.open("user://keybinds.json",FileAccess.READ)
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
		
	leJsonBuffer["keybinds"][foundActionNumber]["key"][keybindNumber] = newKey
	lerawjson = FileAccess.open("user://keybinds.json",FileAccess.WRITE)
	lerawjson.store_string(bufferParse.stringify(leJsonBuffer,"\t"))
	lerawjson.close()
	reloadKeybinds()
	return true
	
func reloadKeybinds():
	makeDefaultKeybinds()
	var keybindConfig = FileAccess.open("user://keybinds.json",FileAccess.READ)
	var configText = keybindConfig.get_as_text()
	actions = InputMap.get_actions()
	
	#i just realized i have absolutely no reason to be deleting the entire stock inputmap
	#for d in actions.size():
		#InputMap.erase_action(actions[d])
		
	Parse.parse(configText)
	var parseData = Parse.data
	for ygu in parseData["keybinds"].size():
		for hbnnkjjijo in parseData["keybinds"][ygu]["key"].size():
			addInputAction(parseData["keybinds"][ygu]["key"][hbnnkjjijo],parseData["keybinds"][ygu]["actionName"])
		
	keybindConfig.close()

func _ready():
	pass
	#makeDefaultKeybinds()
	#reloadKeybinds()
