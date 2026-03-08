extends Node2D
class_name World

@onready var chunk_manager : ChunkManager = $ChunkManager
@onready var map_generator : MapGenerator = $MapGenerator
@onready var player: Player = $Player
@onready var loading_screen = $LoadingScreen

var ID : int = 0
var SEED : int = 0
var WORLD_NAME : String = "World"
var DIR : String = ""

var SIZE : int  = 64 # IN TILES

func _process(delta: float) -> void:
	if Input.is_action_pressed("save"):
		chunk_manager.save_all()
		player.save_player()
		
func setup(world_name: String, seed: int):
	var d := Time.get_datetime_dict_from_system()
	var timestamp := "%04d-%02d-%02d_%02d-%02d-%02d" % [
	d.year, d.month, d.day,
	d.hour, d.minute, d.second
	]
	var directory = "user://worlds/%s/" % timestamp
	DIR = directory
	var chunk_directory = DIR + "chunks/"
	DirAccess.make_dir_recursive_absolute(DIR)
	DirAccess.make_dir_recursive_absolute(chunk_directory)
	print("Added user directory ", DIR)
	var world_data = WorldData.new()
	world_data.name = world_name
	world_data.SEED = seed
	world_data.size = SIZE
	ResourceSaver.save(world_data, DIR+"world_data.tres")
	WORLD_NAME = world_name
	SEED = seed
	map_generator.noise_texture.noise.seed = SEED
	map_generator.set_size(SIZE)
	
func load_world():
	chunk_manager.DIR = DIR + "chunks/"
	chunk_manager.rng.seed = SEED
	chunk_manager.BOUNDS = Vector2i(-SIZE/Util.CHUNK_SIZE, SIZE/Util.CHUNK_SIZE)
	
	player.camera.limit_left = -SIZE*Util.TILE_SIZE
	player.camera.limit_right = SIZE*Util.TILE_SIZE
	player.camera.limit_bottom = SIZE*Util.TILE_SIZE
	player.camera.limit_top = -SIZE*Util.TILE_SIZE
	
	player.set_physics_process(false)
	player.set_process(false)
	print("Chunk manager DIR: ", chunk_manager.DIR)
	var chunks: Array = []
	var chunks_total = (float(map_generator.noise_texture.width*2) / float(Util.CHUNK_SIZE))**2
	for x in range(-map_generator.noise_texture.width/32, map_generator.noise_texture.width/32):
		for y in range(-map_generator.noise_texture.width/32, map_generator.noise_texture.width/32):
			print("Checking if chunk path ", chunk_manager.get_chunk_path(Vector2i(x, y)), " exists...")
			loading_screen.add_to_bar((1.0/chunks_total)*100)
			if ResourceLoader.exists(chunk_manager.get_chunk_path(Vector2i(x, y))):
				print("Exists")
				continue
			map_generator.generate_chunk(Vector2i(x, y), chunk_manager)
			chunk_manager.save_chunk(Vector2i(x, y))
			chunk_manager.offload_chunk(Vector2i(x, y))
			chunks.append(Vector2i(x, y))
			await get_tree().process_frame
			
	await chunk_manager.load_all(Util.get_chunk_from_world(player.position))
	
	player.load_player()
	player.set_physics_process(true)
	player.set_process(true)
	loading_screen.visible = false
