extends TextureProgressBar

var XtoCamera
var YtoCamera

func _ready():
	XtoCamera = global_position.x - Global.CameraX
	YtoCamera = global_position.y - Global.CameraY
	
#Set position
func _process(delta):
	global_position.x = XtoCamera + Global.CameraX
	global_position.y = YtoCamera + Global.CameraY
	
#Health between 0 and 100
func set_health(health:int):
	set_value_no_signal(health)
	
