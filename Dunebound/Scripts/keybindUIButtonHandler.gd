extends ColorRect
@onready var keybindHandler = get_tree().get_root().get_node("RootNode/WORLD/Stuff/NecessaryStuff/keybindHandler")
var onStandby:bool
var receivedKeypress:String
var joob
var myCancelButton
signal fakeButtonPressed
@onready var birthparent = get_parent()
@onready var duplicateKeybindDialogueTimer = Timer.new()
# Called when the node enters the scene tree for the first time.
func isHovering(size,pos):
	return Rect2(pos, size).has_point(get_global_mouse_position())
func _input(event):
	if ((event is InputEventMouseButton and event.button_index==1) or event is InputEventMouseMotion):
		var pressed = event is InputEventMouseButton and event.button_index==1 and event.is_pressed()
		if(isHovering(self.size,self.global_position)):
			if(pressed):
				fakeButtonPressed.emit()
		
	
	if(onStandby&&event.as_text().length()<15):
		if(birthparent.getAllEvents().count(event.physical_keycode)<1):
			receivedKeypress = event.as_text()
			cancelKeybindChange()
			keybindHandler.changeKeybind(self.get_meta("action"),joob.value,receivedKeypress)
		else:
			self.get_node("RichTextLabel").text = "No Duplicate Keybinds!"
			duplicateKeybindDialogueTimer.start()
			await duplicateKeybindDialogueTimer.timeout
			cancelKeybindChange()
		self.get_node("RichTextLabel").text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func keybindSetSequence():
	onStandby = true
	myCancelButton.keybindChangeStarted()
	receivedKeypress = "waiting"
	self.get_node("RichTextLabel").text = "Press A Key..."
func switchToAlternateKeybind(event):
	self.get_node("RichTextLabel").text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func _ready():
	duplicateKeybindDialogueTimer.one_shot = true
	duplicateKeybindDialogueTimer.wait_time = 3
	self.add_child(duplicateKeybindDialogueTimer)
	if joob:
		self.fakeButtonPressed.connect(keybindSetSequence)
		joob.value_changed.connect(self.switchToAlternateKeybind)
func cancelKeybindChange():
	onStandby = false
	myCancelButton.cancelKeybindChange()
func _process(_delta):
	if(!onStandby&&joob!=null):
		var debug = InputMap.action_get_events(self.get_meta("action"))
		self.get_node("RichTextLabel").text= debug[int(joob.value)-1].as_text()
