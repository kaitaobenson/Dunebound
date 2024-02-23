extends RigidBody2D
var foodTypeA:String
func newFoodObject(foodType:String,pos:Vector2,foodParent):
	var file = FileAccess.open("res://internalConfig/food.json",FileAccess.READ)
	var food = JSON.parse_string(file.get_as_text())["food"][foodType]
	var hitbox = RectangleShape2D.new()
	Global.newFood = self.duplicate(15)
	hitbox.size = Vector2(food[2]["hitboxSize_x"],food[3]["hitboxSize_y"])
	Global.newFood.get_node("hitbox").shape = hitbox
	
	#fun
	
	print(Global.run_script("var funnyTexture = preload('"+str(food[0]["texture"])+"');Global.newFood.get_node('Sprite2D').texture = funnyTexture;"))
	#texture needs to fit the hitbox
	Global.newFood.get_node("Sprite2D").scale = Global.newFood.get_node("hitbox").shape.size/Global.newFood.get_node("Sprite2D").texture.get_size()
	Global.newFood.foodTypeA = foodType
	foodParent.add_child(Global.newFood)
	Global.newFood.position = pos
func _process(delta):
	pass
