extends Camera2D
var bufferX = 0

func _ready():
	$PauseScreen/Button.connect("button_down",openthatthing)
	set_zoom(Vector2(1.5,1.5))
	
func openthatthing():
	$uiContainer.visible=true
	
func _physics_process(delta):
	var player_direction = %Player.player_direction
	
	if player_direction == 1:
		bufferX = 300
	if player_direction == -1:
		bufferX = -300
	if player_direction == 0:
		bufferX = 0
		
	var XtoPlayer = (Global.PlayerX - position.x) * 0.1
	var YtoPlayer = (Global.PlayerY - position.y) * 0.1
	
	position.x +=  XtoPlayer + (Global.PlayerX + bufferX - position.x) * 0.1
	position.y +=  YtoPlayer
	


