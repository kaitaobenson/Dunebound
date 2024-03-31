class_name SaveGame
extends Node

const save_path = "user://savegame.tres"

var reset_position: Vector2
@export var save_dict = {
}
var default_dict = {
	"PlayerPos" = Vector2(0,0)
}

func _ready():
	pass

func var_update(value, var_name):
	save_dict[var_name] = value
	print(save_dict)
	save()

func save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_dict)

func loader(desired_var):
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		save_dict = file.get_var()
		if save_dict.get(desired_var) == null:
			save_dict[desired_var] = default_dict[desired_var]
		return save_dict[desired_var]

func clear_save():
	reset_position = Global.Player.position
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(reset_position)
