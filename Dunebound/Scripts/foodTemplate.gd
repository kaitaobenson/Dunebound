extends RigidBody2D
var foodTypeA:String
const pickupSensorSize=1.5
func newFoodObject(foodType:String,pos:Vector2,foodParent):
	var file = FileAccess.open("res://internalConfig/food.json",FileAccess.READ)
	var food = JSON.parse_string(file.get_as_text())["food"][foodType]
	var hitbox = RectangleShape2D.new()
	Global.newFood = self.duplicate(15)
	hitbox.size = Vector2(food[2]["hitboxSize_x"],food[3]["hitboxSize_y"])
	Global.newFood.get_node("hitbox").shape = hitbox
	var funnyImage = Image.load_from_file(food[0]["texture"])
	Global.newFood.get_node("Sprite2D").texture = ImageTexture.create_from_image(funnyImage)
	var pickupSensor = Area2D.new()
	pickupSensor.name = "pickupSensor"
	var sensorHitbox = CollisionShape2D.new()
	sensorHitbox.name = "sensorHitbox"
	sensorHitbox.shape=RectangleShape2D.new()
	sensorHitbox.shape.size = hitbox.size*pickupSensorSize
	#fun
	
	Global.run_script("var funnyTexture = preload('"+str(food[0]["texture"])+"');Global.newFood.get_node('Sprite2D').texture = funnyTexture;")
	#texture needs to fit the hitbox
	Global.newFood.get_node("Sprite2D").scale = Global.newFood.get_node("hitbox").shape.size/Global.newFood.get_node("Sprite2D").texture.get_size()
	Global.newFood.foodTypeA = foodType
	print(Global.newFood)
	foodParent.add_child(Global.newFood)
	Global.newFood.add_child(pickupSensor)
	Global.newFood.get_node("pickupSensor").add_child(sensorHitbox)
	Global.newFood.position = pos
func _process(delta):
	if(self.get_children().size()!=2):
		if(self.get_node("pickupSensor").has_overlapping_bodies()and self.get_parent()!=null):
			var bodies = self.get_node("pickupSensor").get_overlapping_bodies()
			for hff in bodies.size():
				if(bodies[hff].name.contains("Player")):
					bodies[hff].foodPickup = self
				else:
					Global.Player.foodPickup = false
