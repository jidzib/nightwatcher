extends Node2D
class_name ChunkManager

var ID : int = 0
var DIR : String = ""

@export var BOUNDS : Vector2i = Vector2i(-16, 16)
var CHUNKS : Dictionary[Vector2i, Chunk]
var STORED_TILE_OFFSET: int = 16

var CHUNK_SCENE = load("res://Chunk.tscn")

var TILE_ID_TO_LAYER : Dictionary[int, String] = {
	Enums.TileLayer.GRASS : "GrassLayer",
	Enums.TileLayer.FARM : "FarmLayer",
	Enums.TileLayer.WATER : "WaterLayer"
}

var interaction_manager: InteractionManager = InteractionManager.new()

var chunk_load_queue: Array = []
var loading := false
var chunks_per_frame := 1

func _ready():
	add_child(interaction_manager)
	interaction_manager.chunk_manager = self
	
	
func _process(delta: float) -> void:
	if chunk_load_queue.size() > 0:
		process_chunk_queue()

func save_all():
	print("Saving chunks...")
	for chunk in CHUNKS:
		save_chunk(chunk)
	
func load_all():
	var player_pos = Vector2i(0, 0)
	for x in range(player_pos.x-1, player_pos.y+2):
		for y in range(player_pos.x-1, player_pos.y+2):
			load_chunk(Vector2i(x, y))
	
func save_chunk(chunk_coords: Vector2i):
	var chunk_data = ChunkData.new()
	var chunk: Chunk = CHUNKS[chunk_coords]
	for x in range(Util.CHUNK_SIZE):
		for y in range(Util.CHUNK_SIZE):
			var tiles = get_tile_data_in_chunk(Vector2i(x, y), chunk)
			for tile in tiles:
				chunk_data.tile_ids.append(tile[0])
				chunk_data.tile_atlas_x.append(tile[1])
				chunk_data.tile_atlas_y.append(tile[2])
				chunk_data.pos_x.append(x+STORED_TILE_OFFSET)
				chunk_data.pos_y.append(y+STORED_TILE_OFFSET)
				
	for packed_object in chunk.get_objects():
		chunk_data.objects.set(packed_object.tile_coords, packed_object)
		
	ResourceSaver.save(chunk_data, get_chunk_path(DIR, chunk_coords))

func load_chunk(chunk_coords: Vector2i):
	var chunk_data : ChunkData = ResourceLoader.load(get_chunk_path(DIR, chunk_coords))
	var chunk = CHUNK_SCENE.instantiate()
	add_child(chunk)
	CHUNKS.set(chunk_coords, chunk)
	chunk.chunk_coords = chunk_coords
	chunk.position = Vector2(chunk_coords.x * Util.CHUNK_SIZE * Util.TILE_SIZE, chunk_coords.y * Util.CHUNK_SIZE * Util.TILE_SIZE)
	for i in range(len(chunk_data.tile_ids)):
		var id : int = chunk_data.tile_ids[i]
		var atlas_x : int = chunk_data.tile_atlas_x[i]
		var atlas_y : int = chunk_data.tile_atlas_y[i]
		var pos_x : int = chunk_data.pos_x[i] - STORED_TILE_OFFSET
		var pos_y : int = chunk_data.pos_y[i] - STORED_TILE_OFFSET
		
		chunk.get_node(TILE_ID_TO_LAYER[id]).set_cell(Vector2i(pos_x, pos_y), 0, Vector2i(atlas_x, atlas_y))
	for coords in chunk_data.objects:
		var obj = chunk_data.objects[coords]
		if chunk:
			chunk.add_object(obj.CATEGORY, References.OBJECTS[obj.ID], obj.tile_coords)
			await get_tree().process_frame
			# ID to decide what object to load
			# CATEGORY to decide what container to put it in
			# Coords to decide where to put it

func load_chunks(chunks: Array):
	for chunk in chunks:
		if chunk not in chunk_load_queue:
			chunk_load_queue.append(chunk)
	
func offload_chunk(chunk_coords: Vector2i):
	var chunk = CHUNKS[chunk_coords]
	chunk.queue_free()
	CHUNKS.erase(chunk_coords)
	for key in chunk.OBJECT_MAPS:
		for coords in chunk.OBJECT_MAPS[key].objects:
			chunk.OBJECT_MAPS[key].objects[coords].queue_free() 
	
func get_tile_data_in_chunk(tile: Vector2i, chunk: Chunk) -> Array:
	var on_tile = []

	for ID in TILE_ID_TO_LAYER:
		
		var layer = chunk.get_node(TILE_ID_TO_LAYER[ID]).get_cell_tile_data(tile)
		if layer == null:
			continue		
		var atlas_coords = chunk.get_node(TILE_ID_TO_LAYER[ID]).get_cell_atlas_coords(tile)
		var curr_tile: Array = [ID, atlas_coords.x, atlas_coords.y]
		on_tile.append(curr_tile)
		
	return on_tile

func chunk_in_bounds(chunk_coords: Vector2i):
	if (chunk_coords.x < BOUNDS.x or 
		chunk_coords.x >= BOUNDS.y or 
		chunk_coords.y < BOUNDS.x or 
		chunk_coords.y >= BOUNDS.y):
			return false
	return true

func process_chunk_queue():
	var count = 0
	while count < chunks_per_frame and chunk_load_queue.size() > 0:
		var chunk = chunk_load_queue.pop_front()
		load_chunk(chunk)
		count += 1

func get_chunk_path(dir: String, chunk_coords: Vector2i) -> String:
	return "%s/%s_%s.tres" % [dir, chunk_coords.x, chunk_coords.y]
