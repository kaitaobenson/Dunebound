extends Button
@onready var keybindHandler = get_tree().get_root().get_node("Node2D/keybindHandler")
var onStandby:bool
var receivedKeypress:String
var joob
var myCancelButton
@onready var birthparent = get_parent()
@onready var duplicateKeybindDialogueTimer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _input(event):
	if(onStandby&&event.as_text().length()<15):
		if(birthparent.getAllEvents().count(event.physical_keycode)<1):
			receivedKeypress = event.as_text()
			cancelKeybindChange()
			keybindHandler.changeKeybind(self.get_meta("action"),joob.value,receivedKeypress)
		else:
			self.text = "No Duplicate Keybinds!"
			duplicateKeybindDialogueTimer.start()
			await duplicateKeybindDialogueTimer.timeout
			cancelKeybindChange()
		self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func keybindSetSequence():
	onStandby = true
	myCancelButton.keybindChangeStarted()
	receivedKeypress = "waiting"
	self.text = "Press A Key..."
func switchToAlternateKeybind(event):
	self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func _ready():
	duplicateKeybindDialogueTimer.one_shot = true
	duplicateKeybindDialogueTimer.wait_time = 3
	self.add_child(duplicateKeybindDialogueTimer)
	if joob:
		self.button_down.connect(keybindSetSequence)
		joob.value_changed.connect(self.switchToAlternateKeybind)
func cancelKeybindChange():
	onStandby = false
	myCancelButton.cancelKeybindChange()
func _process(delta):
	if(!onStandby&&joob!=null):
		self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
