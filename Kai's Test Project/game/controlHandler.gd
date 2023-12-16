extends Node
var controls = {}
#key is the keys string version (for example, the enter key is "Enter")
func newControl(key, funcToCall):
	controls[key] = funcToCall
func _input(event):
	if(controls.has(event.as_text())):
		controls[event.as_text()]
