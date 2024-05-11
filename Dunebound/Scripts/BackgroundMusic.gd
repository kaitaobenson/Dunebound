extends AudioStreamPlayer

var original_volume = 0.0

func _ready():
	original_volume = volume_db
	volume_db = original_volume + Global.volume
