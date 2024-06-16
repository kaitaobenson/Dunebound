extends Node

var stockActions
@onready var actions:Array = []
var Parse:JSON = JSON.new()
func filterOutNonStock(leShitToFilter:Array):
	var stupidCrap = leShitToFilter
	for x in leShitToFilter.size():
		if(stockActions.find(stupidCrap[x])==-1):
			InputMap.erase_action(stupidCrap[x])
	
func makeDefaultKeybinds()->void:
	if(!FileAccess.file_exists("user://keybinds.json")):
		var parse:JSON = JSON.new()
		var defaultPath = "res://UserData/keybinds.json"
		var defaultkeybinds = FileAccess.open(defaultPath,FileAccess.READ)
		
		var userKeybindFile = FileAccess.open("user://keybinds.json",7)
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
	#no matter how many times i write a fix, this dumbass bug always comes back somehow
	if(keybindNumber>leJsonBuffer["keybinds"][foundActionNumber]["key"].size()):
		leJsonBuffer["keybinds"][foundActionNumber]["key"][0] = newKey
	else:
		leJsonBuffer["keybinds"][foundActionNumber]["key"][keybindNumber] = newKey
	lerawjson = FileAccess.open("user://keybinds.json",FileAccess.WRITE)
	lerawjson.store_string(bufferParse.stringify(leJsonBuffer,"\t"))
	lerawjson.close()
	reloadKeybinds()
	return true
	
func reloadKeybinds():
	var keybindConfig = FileAccess.open("user://keybinds.json",FileAccess.READ)
	var configText = keybindConfig.get_as_text()
	
	#i just realized i have absolutely no reason to be deleting the entire stock inputmap
	#for d in actions.size():
		#InputMap.erase_action(actions[d])
	var fookinDoomb = InputMap.get_actions()
	filterOutNonStock(fookinDoomb)
	actions = InputMap.get_actions()
	Parse.parse(configText)
	var parseData = Parse.data
	for ygu in parseData["keybinds"].size():
		for hbnnkjjijo in parseData["keybinds"][ygu]["key"].size():
			addInputAction(parseData["keybinds"][ygu]["key"][hbnnkjjijo],parseData["keybinds"][ygu]["actionName"])
	actions = InputMap.get_actions()
	keybindConfig.close()

func _ready():
	stockActions = InputMap.get_actions()
	makeDefaultKeybinds()
	reloadKeybinds()
