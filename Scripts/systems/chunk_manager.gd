extends Node2D
class_name ChunkManager

var ID : int = 0
var DIR : String = ""

var BOUNDS : Vector2i
var CHUNKS : Dictionary[Vector2i, Chunk]
var STORED_TILE_OFFSET: int = 16

var CHUNK_SCENE = load("res://Scenes/systems/Chunk.tscn")

var TILE_ID_TO_LAYER : Dictionary[int, String] = {
	Enums.TileLayer.GRASS : "GroundLayer",
	Enums.TileLayer.FARM : "FarmLayer",
	Enums.TileLayer.WATER : "WaterLayer"
}

var chunk_load_queue: Array = []
var chunks_per_frame := 1

var rng = RandomNumberGenerator.new()

var loaded_chunks : Dictionary = {}
var chunk_save_queue : Dictionary = {}

var blocked_tiles: Dictionary[Vector2i, MapObject] = {} # COLLISION
var occupied_tiles: Dictionary[Vector2i, MapObject] = {} # OCCUPANCY

static var ref : PackedScene = load("res://Scenes/core/ChunkManager.tscn")

static func new_chunk_manager(_dir: String, _seed: int, _bounds: Vector2i) -> ChunkManager:
	var _chunk_manager : ChunkManager = ref.instantiate()
	_chunk_manager.DIR = _dir
	_chunk_manager.rng.seed = _seed
	_chunk_manager.BOUNDS = _bounds
	return _chunk_manager

func _ready():
	y_sort_enabled = true
	
func _process(delta: float) -> void:
	if chunk_load_queue.size() > 0:
		process_load_queue()
	if chunk_save_queue.size() > 0:
		process_save_queue()
	if Input.is_action_pressed("save"):
		save_all()
	
	#if Input.is_action_just_pressed("interact"):
		#for chunk in CHUNKS.values():
			#chunk.update_navigation_region()
			
func save_all():
	for chunk in CHUNKS:
		save_chunk(chunk)
	
func load_all(player_chunk_pos: Vector2i):
	for x in range(player_chunk_pos.x-1, player_chunk_pos.y+2):
		for y in range(player_chunk_pos.x-1, player_chunk_pos.y+2):
			load_chunk(Vector2i(x, y))
			
func save_chunk(chunk_coords: Vector2i):
	if not chunk_in_bounds(chunk_coords):
		return
	var chunk_data = ChunkData.new()
	var chunk: Chunk = CHUNKS[chunk_coords]
	for x in range(Util.CHUNK_SIZE):
		for y in range(Util.CHUNK_SIZE):
			var tile = get_tile_data_in_chunk(Vector2i(x, y), chunk)
			if tile[0] == -1:
				continue
			chunk_data.tile_ids.append(tile[0])
			chunk_data.tile_atlas_x.append(tile[1])
			chunk_data.tile_atlas_y.append(tile[2])
			chunk_data.pos_x.append(x+STORED_TILE_OFFSET)
			chunk_data.pos_y.append(y+STORED_TILE_OFFSET)
			
	chunk_data.object_data = chunk.get_object_data()
		
	ResourceSaver.save(chunk_data, get_chunk_path(chunk_coords))

func load_chunk(chunk_coords: Vector2i):
	
	if not chunk_in_bounds(chunk_coords):
		return
		
	var chunk_data : ChunkData = ResourceLoader.load(get_chunk_path(chunk_coords))
	var pos : Vector2 = Vector2(chunk_coords.x * Util.CHUNK_SIZE * Util.TILE_SIZE, chunk_coords.y * Util.CHUNK_SIZE * Util.TILE_SIZE)
	var chunk = Chunk.new_chunk(chunk_coords, pos, self)
	CHUNKS.set(chunk_coords, chunk)
	add_child(chunk)
	for i in range(len(chunk_data.tile_ids)):
		var id : int = chunk_data.tile_ids[i]
		var atlas_x : int = chunk_data.tile_atlas_x[i]
		var atlas_y : int = chunk_data.tile_atlas_y[i]
		var pos_x : int = chunk_data.pos_x[i] - STORED_TILE_OFFSET
		var pos_y : int = chunk_data.pos_y[i] - STORED_TILE_OFFSET

		chunk.GROUND.set_cell(Vector2i(pos_x, pos_y), id, Vector2i(atlas_x, atlas_y))

	var i : int = 0
	var object_data = chunk_data.object_data
	
	var process_count : int = 0
	var max_process : int = 10
	while i < object_data.size():
		var object : MapObject = References.OBJECTS[object_data[i]].instantiate()
		object.decode(object_data, i)
		object.spawn_runtime_dependencies(References)
		chunk.add_object(object, object.tile_coords)
		i += object.get_data_size()
		process_count += 1
		if process_count == max_process:
			process_count = 0
			await get_tree().process_frame
	loaded_chunks.set(chunk_coords, null)
	
func load_chunks(chunks: Array):
	for chunk in chunks:
		if chunk not in chunk_load_queue:
			chunk_load_queue.append(chunk)
	
func offload_chunk(chunk_coords: Vector2i):
	var chunk = CHUNKS[chunk_coords]
	var count : int = 0
	var to_offload : Array[Vector2i] = []
	for key in chunk.OBJECTS:
		to_offload.append(key)
	for key in to_offload:
		chunk.remove_object(key)
		count += 1
	chunk.queue_free()
	CHUNKS.erase(chunk_coords)
	loaded_chunks.erase(chunk_coords)
	
func get_tile_data_in_chunk(tile: Vector2i, chunk: Chunk) -> Array:

	var id = chunk.GROUND.get_cell_source_id(tile)
	var atlas_coords = chunk.GROUND.get_cell_atlas_coords(tile)
	var curr_tile: Array = [id, atlas_coords.x, atlas_coords.y]
		
	return curr_tile

func chunk_in_bounds(chunk_coords: Vector2i) -> bool:
	if (chunk_coords.x < BOUNDS.x or 
		chunk_coords.x >= BOUNDS.y or 
		chunk_coords.y < BOUNDS.x or 
		chunk_coords.y >= BOUNDS.y):
			return false
	return true

func process_load_queue():
	var count = 0
	while count < chunks_per_frame and chunk_load_queue.size() > 0:
		var chunk = chunk_load_queue.pop_front()
		load_chunk(chunk)
		count += 1

func process_save_queue():
	var count = 0
	#while count < chunks_per_frame and chunk_save_queue.size() > 0:
	for chunk in chunk_save_queue:
		if count >= chunks_per_frame:
			return
		if chunk in loaded_chunks:
			save_chunk(chunk)
			offload_chunk(chunk)
			chunk_save_queue.erase(chunk)
			count += 1
		
func get_chunk_path(chunk_coords: Vector2i) -> String:
	return DIR + "%s_%s.tres" % [chunk_coords.x, chunk_coords.y]
