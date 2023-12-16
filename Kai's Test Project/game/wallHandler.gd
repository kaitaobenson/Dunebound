extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_node("/root/mainScene/commonObjLibrary/coolMethods").IsParentLib(self)):
		self.visible = false
		self.get_node("hitbox").set_deferred("disabled", true)
	get_node("/root/mainScene/commonObjLibrary/coolMethods").generateHitbox(self)	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
