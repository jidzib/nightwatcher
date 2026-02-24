extends Node2D
class_name ChunkManager

var ID : int = 0
var DIR : String = ""

@export var BOUNDS : Vector2i = Vector2i(-4, 4)
var CHUNKS : Dictionary[Vector2i, Chunk]
var STORED_TILE_OFFSET: int = 16

var CHUNK_SCENE = load("res://Scenes/systems/Chunk.tscn")

var TILE_ID_TO_LAYER : Dictionary[int, String] = {
	Enums.TileLayer.GRASS : "GroundLayer",
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
	if Input.is_action_pressed("save"):
		save_all()
		
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
				
	for packed_object in chunk.get_objects():
		chunk_data.objects.set(packed_object.tile_coords, packed_object)
		
	ResourceSaver.save(chunk_data, get_chunk_path(chunk_coords))

func load_chunk(chunk_coords: Vector2i):
	if not chunk_in_bounds(chunk_coords):
		return
		
	var chunk_data : ChunkData = ResourceLoader.load(get_chunk_path(chunk_coords))
	var chunk = CHUNK_SCENE.instantiate()
	add_child(chunk)
	CHUNKS.set(chunk_coords, chunk)
	chunk.chunk_coords = chunk_coords
	chunk.position = Vector2(chunk_coords.x * Util.CHUNK_SIZE * Util.TILE_SIZE, chunk_coords.y * Util.CHUNK_SIZE * Util.TILE_SIZE)
	var water_cells := []
	var grass_cells := []
	for i in range(len(chunk_data.tile_ids)):
		var id : int = chunk_data.tile_ids[i]
		var atlas_x : int = chunk_data.tile_atlas_x[i]
		var atlas_y : int = chunk_data.tile_atlas_y[i]
		var pos_x : int = chunk_data.pos_x[i] - STORED_TILE_OFFSET
		var pos_y : int = chunk_data.pos_y[i] - STORED_TILE_OFFSET
	
		#if id == Enums.TileLayer.GRASS:
			#grass_cells.append(Vector2i(pos_x, pos_y))
			#
		#else:
			#water_cells.append(Vector2i(pos_x, pos_y))
		chunk.GROUND.set_cell(Vector2i(pos_x, pos_y), id, Vector2i(atlas_x, atlas_y))
	#print("Number of grass cells: ", len(grass_cells))
	#print("Number of water cells: ", len(water_cells))
	
	#chunk.GROUND.set_cells_terrain_connect(
		#water_cells,
		#0,
		#1,
	#)
	#chunk.GROUND.set_cells_terrain_connect(
		#grass_cells,
		#0,
		#0
	#)
	
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

func process_chunk_queue():
	var count = 0
	while count < chunks_per_frame and chunk_load_queue.size() > 0:
		var chunk = chunk_load_queue.pop_front()
		load_chunk(chunk)
		count += 1

func get_chunk_path(chunk_coords: Vector2i) -> String:
	return DIR + "%s_%s.tres" % [chunk_coords.x, chunk_coords.y]
