extends Button
@onready var keybindHandler = self.get_parent().get_parent().get_parent().get_node("keybindHandler")
var onStandby:bool
var receivedKeypress:String
@onready var birthparent = self.get_parent().get_parent().get_parent().get_node("Node2D").get_node("Control")
# Called when the node enters the scene tree for the first time.
func _input(event):
	if (onStandby&&event.as_text().length()<15):
		print(event.as_text())
		receivedKeypress = event.as_text()
		onStandby = false
		print(self.get_meta("correspondingTicker"))
		var joob = self.get_meta("correspondingTicker")
		keybindHandler.changeKeybind(self.get_meta("action"),get_node(joob).value,receivedKeypress)
		self.text = InputMap.action_get_events(self.get_meta("action"))[get_node(joob).value].as_text()
		birthparent.reloadKeybindUI()
func keybindSetSequence():
	onStandby = true
	receivedKeypress = "waiting"
	self.text = "Press A Key..."
func _ready():
	self.button_down.connect(keybindSetSequence)
