extends Node
var scrollbarMax
var actions = []
var ignoreThisVar:Vector2
var Parse:JSON = JSON.new()

#il figure out how to scale ui depending on window size to make it look nice later, for now i just want it to appear in the camera
const uiCrapOffsetQuickFix:int = 200
const TEXT_OFFSET_THINGYMABOBBER:int = 100
const uiScaleDownQuickPatch:float = 0.5 
#TODO: name a variable "TacticsComradesTactics"
func getScrollbarSize():
	var shit = actions
	scrollbarMax = 350+65*shit.size()
func replaceWithSpaces(thingydingy:String):
	var dingythingy = thingydingy
	for wrkjn in thingydingy.length():
		if(thingydingy[wrkjn]=="_"||thingydingy[wrkjn]=="-"):
			dingythingy[wrkjn] = " "
	return dingythingy
func getChildrenOfTypeTicker():
	var brats:Array = self.get_children()
	var bigBalling = []
	for ifwejk in brats.size():
		if(brats[ifwejk] is SpinBox):
			bigBalling.push_back(brats[ifwejk])
	return bigBalling
func generateZeroArray(size):
	var leArray:Array = []
	for xyzballshbihbhbugvbhu in size:
		leArray.push_back(0)
	return leArray
#i dont even remember why i made this function wtf
#oh now i do nvm
func getAllEventse():
	var thingydingymalingypasingy:Array = InputMap.get_actions()
	var theotherthingy:Array = []
	var theotherdingybuffer
	for yhuib in thingydingymalingypasingy.size():
		theotherdingybuffer = InputMap.action_get_events(thingydingymalingypasingy[yhuib])
		theotherthingy.push_back(theotherdingybuffer.size())
	return theotherthingy
func getAllEvents():
	var thingydingymalingypasingy:Array = InputMap.get_actions()
	var theotherthingy:Array = []
	var theotherdingybuffer
	for yhuib in thingydingymalingypasingy.size():
		theotherdingybuffer = InputMap.action_get_events(thingydingymalingypasingy[yhuib])
		for y in theotherdingybuffer.size():
			if(!theotherdingybuffer[y] is InputEventJoypadButton and !theotherdingybuffer[y] is InputEventJoypadMotion):
				theotherthingy.push_back(theotherdingybuffer[y].physical_keycode)
	return theotherthingy
func returnCurrentTickerPositions()->Array:
	var deArray:Array = []
	var tickers:Array = []
	tickers=self.getChildrenOfTypeTicker()
	for ygbhhuy in tickers.size():
		deArray.push_back(tickers[ygbhhuy].value)
	return deArray
func filterStockKeybinds():
	#yippee more funny json stuff
	var stuffToRemove:Array
	var isCustom:bool
	if(!FileAccess.file_exists("user://keybinds.json")):
		var defaultkeybinds = FileAccess.open("res://UserData/keybinds.json",FileAccess.READ)
		var userKeybindFile = FileAccess.open("user://keybinds.json",FileAccess.WRITE)
		userKeybindFile.store_string(defaultkeybinds.get_as_text())
		userKeybindFile.close()
	var keybindData = FileAccess.open("user://keybinds.json",FileAccess.READ)
	for z in actions.size():
		if(actions[z-1].contains("ui")):
			stuffToRemove.append(z-1)
	for i in stuffToRemove.size():
		actions.pop_front()
		

func reloadKeybindUI()->void:
	filterStockKeybinds()
	var tickerValues = getAllEventse()
	var myChildren = get_children()
	for knife in myChildren.size():
		myChildren[knife].queue_free()
	for retghghhvh in actions.size():
		var newText = Label.new()
		var newButton = $"../../../Templates/keybindButton".duplicate(15)
		var newTicker = $"../../../Templates/fakeTicker".duplicate(15)
		var newCancelButton = $"../../../Templates/cancelButton".duplicate(15)
		newCancelButton.visible = true
		newButton.visible = true
		newTicker.visible = true
		newCancelButton.visible = true
		newButton.set_meta("action",actions[retghghhvh])
		newTicker.min_value = 0
		newTicker.max_value = InputMap.action_get_events(actions[retghghhvh]).size()-1
		newTicker.name = "ticker" + str(Time.get_unix_time_from_system())
		newTicker.value = 0
		newButton.position.y  =((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)
		newCancelButton.position.y=((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)
		newButton.get_node("RichTextLabel").text = InputMap.action_get_events(actions[retghghhvh])[0].as_text()
		newText.position.x = (10+uiScaleDownQuickPatch)+uiCrapOffsetQuickFix
		newText.position.y =  (((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch-25)+uiCrapOffsetQuickFix)
		newTicker.position.y =  ((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)
		newText.z_index =99
		newButton.z_index=999
		newCancelButton.z_index=999
		newButton.visible = true
		newCancelButton.visible = false
		newText.add_theme_font_size_override("font_size",66)
		newText.text = replaceWithSpaces(actions[retghghhvh]).capitalize()+" :"
		newButton.position.x = ((newText.position.x+150)*uiScaleDownQuickPatch)+uiCrapOffsetQuickFix+newText.text.length()*10
		newCancelButton.position.x = ((newButton.position.x+300)*uiScaleDownQuickPatch)+uiCrapOffsetQuickFix
		newTicker.position.x = ((newCancelButton.position.x+300)*uiScaleDownQuickPatch)+uiCrapOffsetQuickFix
		newText.scale = ignoreThisVar
		newTicker.scale = ignoreThisVar
		newButton.scale = ignoreThisVar
		newCancelButton.scale = ignoreThisVar
		self.add_child(newText)
		self.add_child(newTicker)
		newButton.joob = newTicker
		self.add_child(newButton)
		newCancelButton.leSillyGoober = newButton
		self.add_child(newCancelButton)
		newButton.myCancelButton = newCancelButton
func _ready():
	ignoreThisVar=Vector2(uiScaleDownQuickPatch,uiScaleDownQuickPatch)
	actions = InputMap.get_actions()
	reloadKeybindUI()
