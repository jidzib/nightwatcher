extends Node2D
class_name World

@onready var chunk_manager : ChunkManager = $ChunkManager
@onready var map_generator : MapGenerator = $MapGenerator
#var interaction_manager : InteractionManager = InteractionManager.new()

var ID : int = 0
var SEED : int = 0
var WORLD_NAME : String = "World"
var DIR : String = ""

func setup(world_name: String, seed: int):
	var d := Time.get_datetime_dict_from_system()
	var timestamp := "%04d-%02d-%02d_%02d-%02d-%02d" % [
	d.year, d.month, d.day,
	d.hour, d.minute, d.second
	]
	var directory = "user://worlds/%s/" % timestamp
	DIR = directory
	DirAccess.make_dir_recursive_absolute(DIR)
	print("Added user directory ", DIR)
	var world_data = WorldData.new()
	world_data.name = world_name
	world_data.SEED = seed
	ResourceSaver.save(world_data, DIR+"world_data.tres")
	WORLD_NAME = world_name
	SEED = seed
	map_generator.noise_texture.noise.seed = SEED
	
func load_world():
	chunk_manager.DIR = DIR
	var chunks: Array = []
	for x in range(-map_generator.noise_texture.width/32, map_generator.noise_texture.width/32):
		for y in range(-map_generator.noise_texture.width/32, map_generator.noise_texture.width/32):
			if ResourceLoader.exists(chunk_manager.get_chunk_path(DIR, Vector2i(x, y))):
				continue
			map_generator.generate_chunk(Vector2i(x, y), chunk_manager)
			chunk_manager.save_chunk(Vector2i(x, y))
			chunk_manager.offload_chunk(Vector2i(x, y))
			chunks.append(Vector2i(x, y))
			await get_tree().process_frame
	chunk_manager.load_all()
