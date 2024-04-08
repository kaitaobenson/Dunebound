extends Node
var scrollbarMax
var actions = []
var ignoreThisVar:Vector2
@onready var scrollbar = get_parent().get_parent().get_node("PauseScreen").get_node("VScrollBar")
#il figure out how to scale ui depending on window size to make it look nice later, for now i just want it to appear in the camera
const uiCrapOffsetQuickFix:int = 300
const TEXT_OFFSET_THINGYMABOBBER:int = 100
const uiScaleDownQuickPatch:float = 0.5 
#TODO: name a variable "TacticsComradesTactics"
func getScrollbarSize():
	var shit = InputMap.get_actions()
	scrollbarMax = 350+65*shit.size()
	scrollbar.max_value = (scrollbarMax/65)-9
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
func getAllEvents():
	var thingydingymalingypasingy:Array = InputMap.get_actions()
	var theotherthingy:Array = []
	var theotherdingybuffer
	for yhuib in thingydingymalingypasingy.size():
		theotherdingybuffer = InputMap.action_get_events(thingydingymalingypasingy[yhuib])
		for abbagabba in theotherdingybuffer.size():
			
			theotherthingy.push_back(theotherdingybuffer[abbagabba].physical_keycode)
	return theotherthingy
func returnCurrentTickerPositions()->Array:
	var deArray:Array = []
	var tickers:Array = []
	tickers=self.getChildrenOfTypeTicker()
	for ygbhhuy in tickers.size():
		deArray.push_back(tickers[ygbhhuy].value)
	return deArray
func reloadKeybindUI():
	var tickerValues = getAllEvents()
	var myChildren = get_children()
	for knife in myChildren.size():
		myChildren[knife].queue_free()
	for retghghhvh in actions.size():
		var newText = Label.new()
		var newButton = $"../../../Templates/keybindButton".duplicate(15)
		var newTicker = SpinBox.new()
		var newCancelButton = $"../../../Templates/cancelButton".duplicate(15)
		newButton.set_meta("action",actions[retghghhvh])
		newTicker.min_value = 0
		newTicker.max_value = InputMap.action_get_events(actions[retghghhvh]).size()-1
		newTicker.name = "ticker" + str(Time.get_unix_time_from_system())
		newTicker.value = tickerValues[retghghhvh]
		newButton.position.y  =((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)-scrollbar.value*65
		newCancelButton.position.y=((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)-scrollbar.value*65
		newButton.text = InputMap.action_get_events(actions[retghghhvh])[0].as_text()
		newText.position.x = (10+uiScaleDownQuickPatch)+uiCrapOffsetQuickFix
		newText.position.y =  (((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch-25)+uiCrapOffsetQuickFix)-scrollbar.value*65
		newTicker.position.y =  ((retghghhvh*65+TEXT_OFFSET_THINGYMABOBBER)*uiScaleDownQuickPatch+uiCrapOffsetQuickFix)-scrollbar.value*65
		newText.z_index =99
		newButton.z_index=999
		newCancelButton.z_index=999
		newButton.visible = true
		newCancelButton.visible = false
		newText.add_theme_font_size_override("font_size",66)
		newText.text = replaceWithSpaces(actions[retghghhvh])+" :"
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
	getScrollbarSize()
	scrollbar.scrolling.connect(reloadKeybindUI)
