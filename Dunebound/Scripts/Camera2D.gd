extends Camera2D

var _bufferX = 0

@onready var top = $"../WorldBarrier/Top"
@onready var bottom = $"../WorldBarrier/Bottom"
@onready var left = $"../WorldBarrier/Left"
@onready var right = $"../WorldBarrier/Right"

func _init():
	Global.camera = self

func _ready():
	set_bounds()
	get_parent().get_node("UI/PauseScreen/Button").connect("button_down",openthatthing)


#THIS SHOULD NOT BE HEREREeEE
func openthatthing():
	print("go screw yourself stupid ah code")
	$uiContainer.visible=true
	get_parent().get_node("stupidScrollbarBullshitWhyDOesGodotNeedToBeLikeThis/VScrollBar").Visible= !get_parent().get_node("stupidScrollbarBullshitWhyDOesGodotNeedToBeLikeThis/VScrollBar").Visibl


func _physics_process(delta):
	var player_direction = Global.Player.player_sprite_direction
	
	if player_direction == 1:
		_bufferX = 20
	if player_direction == -1:
		_bufferX = -20
	if player_direction == 0:
		_bufferX = 0
	var XtoPlayer = (Global.Player.global_position.x - global_position.x) * 0.1
	var YtoPlayer = (Global.Player.global_position.y - global_position.y) * 0.1
	
	global_position.x +=  XtoPlayer + _bufferX
	global_position.y +=  YtoPlayer #- 8.5


func set_bounds():
	#screen height / 2 = 324
	#screen width  / 2 = 576
	limit_bottom = bottom.position.y - 324
	limit_top = top.position.y + 324
	limit_right = right.position.x - 324
	limit_left = left.position.x + 324
