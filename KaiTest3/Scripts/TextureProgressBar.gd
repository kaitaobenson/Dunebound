extends TextureProgressBar

#Health between 0 and 100
func set_health(health:int):
	set_value_no_signal(health)
	
