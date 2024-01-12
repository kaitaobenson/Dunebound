extends Sprite2D
var mousePressed:bool = false
var activeGrappleShooting:bool = false
var activeGrappleGoUp:bool = false
var grappleTargetLocation:Vector2 = Vector2(0,0)
var rope:Line2D
var hook:CharacterBody2D
var sceneRoot 
var areaChecker:Area2D
var prebakeSwingPathTemplate:Array = []
func swingPathGenerator(centerPoint:Vector2,aboveCenterPoint:Vector2)->Array:
	var transformedSwing:Array = prebakeSwingPathTemplate.duplicate()
	print(centerPoint)
	print(aboveCenterPoint)
	print(aboveCenterPoint.distance_to(centerPoint))
	var differenceFromTenplate = 1/(aboveCenterPoint.distance_to(centerPoint)/-30)
	for j in transformedSwing.size():
		transformedSwing[j] = Vector2(transformedSwing[j].x,transformedSwing[j].y*differenceFromTenplate)+centerPoint
	return transformedSwing
func checkForEntity(pos:Vector2):
	var raycast = RayCast2D.new()
	raycast.target_position = pos
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true
	sceneRoot.add_child(raycast)
	raycast.force_raycast_update()
	var bigFancyPantsResultRThingyMajingyAbAbAbGabba =  raycast.get_collider()
	raycast.queue_free()
	return bigFancyPantsResultRThingyMajingyAbAbAbGabba!=null
func returnForEntity(pos:Vector2):
	var raycast = RayCast2D.new()
	raycast.target_position = pos
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true
	sceneRoot.add_child(raycast)
	raycast.force_raycast_update()
	var bigFancyPantsResultRThingyMajingyAbAbAbGabba =  raycast.get_collider()
	raycast.queue_free()
	return bigFancyPantsResultRThingyMajingyAbAbAbGabba
func die():
	#doesnt work yet
	pass
	#self.rope.queue_free()
	#self.hook.queue_free()
func _ready():
	sceneRoot = get_tree().current_scene
	prebakeSwingPathTemplate.resize(300)
	var incrementer:float = -30
	#thanks to a random graph i found on desmos for the equation!
	for x in 300:
		prebakeSwingPathTemplate[x] = Vector2(incrementer,-sqrt(pow(-incrementer,2)+pow(30,2)))
	#self.connect("tree_exiting",die())
func _physics_process(delta):
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)&&!(activeGrappleGoUp||activeGrappleShooting)&&checkForEntity(get_viewport().get_mouse_position())):
		mousePressed = true
		
		activeGrappleShooting = true
		activeGrappleGoUp = false
		grappleTargetLocation = get_viewport().get_mouse_position()
		rope = Line2D.new()
		rope.add_point(self.position,0)
		rope.add_point(grappleTargetLocation,1)
		hook = get_node("hookTemplate").duplicate(15)
		hook.position = self.get_parent().position
		hook.rotation = (grappleTargetLocation - hook.position).normalized().angle()
		hook.velocity = Vector2(sin(hook.rotation),cos(hook.rotation))*delta*self.get_meta("hookSpeed")
		hook.get_node("hitbox").set_deferred("disabled",false)
		sceneRoot.add_child(rope)
		sceneRoot.add_child(hook)
	if(mousePressed):
		if(!Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			self.get_parent().grappleDownProcessActive = false
			hook.queue_free()
			rope.queue_free()
			activeGrappleShooting = false
			activeGrappleGoUp = false
			mousePressed = false
			return
		if(activeGrappleShooting&&!activeGrappleGoUp):
			hook.rotation = (grappleTargetLocation - hook.position).normalized().angle()
			hook.velocity = Vector2(cos(hook.rotation),sin(hook.rotation))*delta*self.get_meta("hookSpeed")
			var goofing = hook.move_and_collide(hook.velocity)
			rope.set_point_position(1,hook.position)
			rope.set_point_position(0,self.get_parent().position)
			if(goofing&&!goofing.get_collider().has_method("noGrapple")):
				#grapple hook hit something. start going up!
				activeGrappleShooting = false
				activeGrappleGoUp = true
				self.get_parent().grappleDown()
