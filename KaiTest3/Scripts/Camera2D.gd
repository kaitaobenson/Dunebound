extends Camera2D

func _ready():
	get_node("PauseScreen/Button").connect("button_down",openthatthing)
func openthatthing():
	get_node("uiContainer").visible=true
