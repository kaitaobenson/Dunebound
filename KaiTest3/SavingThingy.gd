class_name SaveGame
extends Node

const save_path = "user://savegame.tres"

var reset_position: Vector2
@export var SpawnPos : Vector2 

func _ready():
	pass
	#clear_save()
	#loader()

func spawn_pos_update(CheckpointPos : Vector2):
	SpawnPos = CheckpointPos
	save()

func save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(SpawnPos)

func loader():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		SpawnPos = file.get_var(true)
		return SpawnPos

func clear_save():
	reset_position = Global.Player.position
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(reset_position)
