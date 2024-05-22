class_name SaveGame
extends Node



const save_path = "user://savegame.tres"
var loaded
var save_dict: Dictionary = {
}


func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	Global.saver_loader = self
	print(save_path)
	loader()
	
	if save_dict.get("KillList") == null:
		save_dict["KillList"] = []


func _process(_delta):
	if save_dict.get("KillList") == null:
		save_dict["KillList"] = []
	#print(save_dict)


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
		print(file.get_var())
		if(file.get_var()!=null):
			save_dict = file.get_var()


func find_saved_value(desired_var):
	return save_dict.get(desired_var)


func clear_save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	save_dict.clear()
	file.store_var(save_dict)
