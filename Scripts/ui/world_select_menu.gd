extends UI
class_name WorldSelectMenu

@export var world_list : VBoxContainer
var world_entry : PackedScene = load("uid://dwvmrpealyaki")

func _ready() -> void:
	#await get_tree().root.ready
	for world_path in scan_folder():
		var world : WorldEntry = world_entry.instantiate()
		var world_data = ResourceLoader.load(world_path + "world_data.tres")
		world_list.add_child(world)
		world.setup(world_data.name, world_path)

func scan_folder() -> Array[String]:
	var results : Array[String] = []
	
	var dir = DirAccess.open(Util.DIR)
	
	dir.list_dir_begin()
	
	var entry = dir.get_next()
	while entry != "":
		if not entry.begins_with("."):
			results.append(Util.DIR+entry+"/")
		entry = dir.get_next()
	
	dir.list_dir_end()
	return results
