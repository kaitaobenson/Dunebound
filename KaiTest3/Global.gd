extends Node

var PlayerX
var PlayerY
var PlayerPosition

var TimeOfDay = 0
var DayCount = 1

func texture(name:String):
	#make a texture, load an image into it, and return the texture!
	var image = Image.new()
	var texture = ImageTexture.new()
	image.load(name)
	texture.create_from_image(image)
	return texture
