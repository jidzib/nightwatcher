extends Control

@onready var world_list  = $WorldList/VBoxContainer

var world_entry = load("res://Scenes/ui/WorldEntry.tscn")

func _ready():
	for world_path in scan_folder():
		var world = world_entry.instantiate()
		var world_data = ResourceLoader.load(world_path+"world_data.tres")
		world_list.add_child(world)
		world.setup(world_data.name, world_path)
		
func scan_folder():
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
