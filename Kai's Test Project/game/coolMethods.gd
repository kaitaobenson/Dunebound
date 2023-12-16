extends Node
#this object holds functions that are handy to have around
#the naim arg only needs the name of the file, because it automatically loads from assets/textures
func texture(naim:String):
	#make a texture, load an image into it, and return the texture!
	var le_image = Image.new()
	var le_texture = ImageTexture.new()
	le_image.load("res://assets/textures/"+naim)
	le_texture.create_from_image(le_image)
	return le_texture
	#do you need a hitbox, but dont want to tediously get the sizing right yourself? well then generateHitbox is for you! pass it the object and it will make the hitbox size whatever the sprite size is
func generateHitbox(obbect):
	obbect.get_node("hitbox").shape.extents = (obbect.get_node("Sprite2D").get_rect().size*obbect.get_node("Sprite2D").scale)/2
	obbect.get_node("hitbox").position.x = 0
	obbect.get_node("hitbox").position.y = 0
func IsParentLib(obbect):
	return obbect.get_parent()==get_node("/root/mainScene/commonObjLibrary")
