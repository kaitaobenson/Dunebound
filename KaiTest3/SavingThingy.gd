class_name SaveGame
extends Node

const save_path = "user://savegame.tres"
var loaded
var save_dict: Dictionary = {
}

var default_dict: Dictionary = {
	"PlayerPos" = Vector2(0,0),
	"Health" = 100
}
func _init():
	loader()

func _ready():
	pass

func var_update(value, var_name):
	save_dict[var_name] = value
	save()

func save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_dict)
	

func loader():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		save_dict = file.get_var()

func find_saved_value(desired_var): 
	save_dict.get(desired_var)
	if save_dict.get(desired_var) == null:
		save_dict[desired_var] = default_dict[desired_var]
	return save_dict[desired_var]

