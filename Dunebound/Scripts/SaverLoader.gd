class_name SaveGame
extends Node

@export var turned_on: bool = true

const save_path = "user://savegame.tres"
var loaded
var save_dict: Dictionary = {
}

var default_dict: Dictionary = {
	"SpawnPos" = Vector2(0,0),
	"Health" = 100
}
func _process(delta):
	pass

func _init():
	loader()
	Global.saver_loader = self


func var_update(value, var_name):
	save_dict[var_name] = value
	if turned_on:
		save()
	else:
		clear_save()

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

func clear_save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	save_dict.clear()
	file.store_var(save_dict)
