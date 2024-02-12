extends Sprite2D

func _ready():
	$Text.set_text(get_meta("ScrollText"))

func _on_area_2d_body_entered(body):
	if body == %Player:
		$Text.set_visible(true)
		
