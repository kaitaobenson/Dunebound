extends Sprite2D

@export var central_pos: Vector2 = Vector2(0,0)
@export var radius: float = 400.0

var timer: float = 0.0
var angle: float = 0.0

#Why 8 and not 6??  Because extra line horizontal silly just count them
var starting_angle: float

func _ready():
	await get_tree().process_frame
	starting_angle = 360 / 8 * Global.begin_phase

func _process(delta):
	timer += delta
	
	position.x = radius * cos(angle) + central_pos.x
	position.y = radius * sin(angle) + central_pos.y
	
	angle = deg_to_rad(timer / Global.DAY_LENGTH * 360 + starting_angle)
	if angle == 2 * PI:
		angle = 0
