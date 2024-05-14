class_name SaveGame
extends Node

var clear_current_save: bool = false

const save_path = "user://savegame.tres"
var loaded
var save_dict: Dictionary = {
}

var default_dict: Dictionary = {
	"SpawnPos" = Vector2(12500,0),
	"Health" = 100,
	"RespawnPos" = Vector2(0,0),
}


func _init():
	Global.saver_loader = self
	loader()
	
	if clear_current_save:
		clear_save()
	
	if save_dict.get("KillList") == null:
		save_dict["KillList"] = []
	
	if save_dict.get("RespawnPos") == null:
		save_dict["RespawnPos"] = Vector2(0,0)


func _process(delta):
	pass


func var_update(value, var_name):
	if var_name == "KillList":
		save_dict[var_name].append(value)
	else:
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
	if save_dict.get(desired_var) == null:
		save_dict[desired_var] = default_dict[desired_var]
	return save_dict[desired_var]


func clear_save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	save_dict.clear()
	file.store_var(save_dict)
