extends Button
@onready var keybindHandler = get_tree().get_root().get_node("Node2D/keybindHandler")
var onStandby:bool
var receivedKeypress:String
var joob
@onready var birthparent = get_parent()
# Called when the node enters the scene tree for the first time.
func _input(event):
	if (onStandby&&event.as_text().length()<15):
		print(event.as_text())
		receivedKeypress = event.as_text()
		onStandby = false
		keybindHandler.changeKeybind(self.get_meta("action"),joob.value,receivedKeypress)
		self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
		birthparent.reloadKeybindUI()
func keybindSetSequence():
	onStandby = true
	receivedKeypress = "waiting"
	self.text = "Press A Key..."
func switchToAlternateKeybind(event):
	self.text = InputMap.action_get_events(self.get_meta("action"))[joob.value].as_text()
func _ready():
	print(joob)
	if joob:
		self.button_down.connect(keybindSetSequence)
		joob.value_changed.connect(self.switchToAlternateKeybind)
