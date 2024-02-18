extends RigidBody2D
var foodTypeA:String
func newFoodObject(foodType:String,pos:Vector2,foodParent):
	var file = FileAccess.open("res://internalConfig/food.json",FileAccess.READ)
	var food = JSON.parse_string(file.get_as_text())["food"][foodType]
	var newFood = self.duplicate(15)
	var hitbox = RectangleShape2D.new()
	hitbox.size = Vector2(food[2]["hitboxSize_x"],food[3]["hitboxSize_y"])
	newFood.get_node("hitbox").shape = hitbox
	newFood.get_node("Sprite2D").texture = Global.texture(food[0]["texture"])
	newFood.foodTypeA = foodType
	foodParent.add_child(newFood)
	newFood.position = pos
func _process(delta):
	pass
