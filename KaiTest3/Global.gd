extends Node

var PlayerX
var PlayerY
var PlayerPosition

var newFood
var TimeOfDay = 0
var DayCount = 1

#run code from a string. yes, our codebase is about to get really bad really fast
func run_script(input):
	var what_is_wrong_with_me = RefCounted.new()
	var script = GDScript.new()
	script.set_source_code("func eval():" + input)
	script.reload()
	what_is_wrong_with_me.set_script(script)
	return what_is_wrong_with_me.eval()
	
func texture(waa):
	#make a texture, load an image into it, and return the texture!
	var le_texture = ImageTexture.new()
	le_texture.create_from_image(waa)
	return le_texture
