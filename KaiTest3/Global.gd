extends Node

var PlayerX
var PlayerY
var PlayerPosition

var TimeOfDay = 0
var DayCount = 1

func texture(naim:String):
	#make a texture, load an image into it, and return the texture!
	var le_image = Image.new()
	var le_texture = ImageTexture.new()
	le_image.load(naim)
	le_texture.create_from_image(le_image)
	return le_texture
