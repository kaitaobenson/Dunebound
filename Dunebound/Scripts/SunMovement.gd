extends Sprite2D

@export var central_pos: Vector2 = Vector2(0,0)
@export var radius: float = 400.0

var timer: float = 0.0
var angle: float = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	timer += delta
	
	position.x = radius * cos(angle) + central_pos.x
	position.y = radius * sin(angle) + central_pos.y
	
	angle = deg_to_rad(timer / Global.DAY_LENGTH * 360)
	if angle == 2 * PI:
		angle = 0
