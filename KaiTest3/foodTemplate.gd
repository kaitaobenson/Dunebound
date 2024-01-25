extends RigidBody2D
func texture(naim:String):
	#make a texture, load an image into it, and return the texture!
	var le_image = Image.new()
	var le_texture = ImageTexture.new()
	le_image.load(naim)
	le_texture.create_from_image(le_image)
	return le_texture
func newFoodObject(foodType:String,pos:Vector2,foodParent):
	var file = FileAccess.open("res://internalConfig/food.json",FileAccess.READ)
	var food = JSON.parse_string(file.get_as_text())["food"][foodType]
	var newFood = self.duplicate(15)
	var hitbox = RectangleShape2D.new()
	hitbox.size = Vector2(food[3]["hitboxSize_x"],food[4]["hitboxSize_y"])
	newFood.get_node("hitbox").shape = hitbox
	newFood.get_node("Sprite2D").texture = texture(food[1]["texture"])
	foodParent.add_child(newFood)
	newFood.position = pos
func _process(delta):
	pass
