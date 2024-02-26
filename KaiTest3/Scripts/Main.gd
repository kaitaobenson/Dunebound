extends TextureButton

#this script handles stuff that should happen in every single level
#attach it to the root of every single levels scene
func pos(x,y):
	#vector2 takes too long to type
	return Vector2(x,y)
func _ready():
	var foodHandlerCreation = preload("res://Scenes/food_template.tscn").instantiate()
	foodHandlerCreation.name = "foodHandler"
	add_child(foodHandlerCreation)
	var foodHandler = get_node("foodHandler")
	
	foodHandler.newFoodObject("exampleFood",pos(375,375),self)
func _process(delta):
	pass
