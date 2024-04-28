extends Node


var player_temp: float 

var inventory: Object
var Player: Object
var camera: Object
var saver_loader: Object
var temperature_ui: Object
var fader: Object
var kai_ui_container: Object

# 1-6 phase
var current_phase: int
var begin_phase: int
var phase_length: float
var DAY_LENGTH: int
var day_count = 1


var temperature

#???? What is this
var newFood


func texture(name:String):
	#make a texture, load an image into it, and return the texture!
	var image = Image.new()
	var texture = ImageTexture.new()
	image.load(name)
	texture.create_from_image(image)
	return texture

#run code from a string. yes, our codebase is about to get really bad really fast
func run_script(input):
	var what_is_wrong_with_me = RefCounted.new()
	var script = GDScript.new()
	script.set_source_code("func eval():" + input)
	script.reload()
	what_is_wrong_with_me.set_script(script)
	return what_is_wrong_with_me.eval()
