extends Button
@onready var keybindHandler = get_tree().get_root().get_node("Node2D/keybindHandler")
var onStandby:bool
var receivedKeypress:String
var joob
@onready var birthparent = get_parent()
@onready var duplicateKeybindDialogueTimer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _input(event):
	if (onStandby&&event.as_text().length()<15):
		print(birthparent.getAllEvents())
		print(event)
		print(birthparent.getAllEvents().count(event.as_text()))
		if(birthparent.getAllEvents().count(event.physical_keycode)<1):
			print(event.as_text())
			receivedKeypress = event.as_text()
			onStandby = false
			keybindHandler.changeKeybind(self.get_meta("action"),joob.value,receivedKeypress)
			print(joob.value)
			print(InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text())
		else:
			self.text = "No Duplicate Keybinds!"
			duplicateKeybindDialogueTimer.start()
			await duplicateKeybindDialogueTimer.timeout
			print("dialogue past")
		self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func keybindSetSequence():
	onStandby = true
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
