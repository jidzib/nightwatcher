extends Area2D
class_name Chunk
@export var chunk_coords: Vector2i
@onready var GROUND: TileMapLayer = $GroundLayer
	
#@onready var navigation_region : NavigationRegion2D = $NavigationRegion2D

var OBJECTS : Dictionary = {}
var ENTITY_LIST : Dictionary = {}

var TILE_MAPS: Dictionary = {}
					
var load_distance: int = 2

var loading := false
var changed = false

@onready var x_coord = $X
@onready var y_coord = $Y

var parent : ChunkManager

static var ref : PackedScene = load("res://Scenes/systems/Chunk.tscn")

static func new_chunk(_chunk_coords: Vector2i, _position: Vector2, _parent: ChunkManager) -> Chunk:
	var _chunk : Chunk = ref.instantiate()
	_chunk.chunk_coords = _chunk_coords
	_chunk.position = _position
	_chunk.parent = _parent
	return _chunk

func _ready():
	x_coord.text = str(chunk_coords.x)
	y_coord.text = str(chunk_coords.y)
	
	TILE_MAPS = {
		Enums.TileLayer.GRASS : GROUND,
	}

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("player entered new chunk")
		var chunk_manager = parent
		var new_chunk_square: Dictionary
		for x in range(chunk_coords.x-load_distance, chunk_coords.x+load_distance+1):
			for y in range(chunk_coords.y-load_distance, chunk_coords.y+load_distance+1):
				new_chunk_square.set(Vector2i(x, y), null)
		save_self(chunk_manager, new_chunk_square)
		load_self(chunk_manager, new_chunk_square)
		body.chunk_coords = chunk_coords

func add_object(object, local_origin_coords: Vector2i) -> bool:
	var global_origin_coords: Vector2i = local_origin_coords + chunk_coords * Util.CHUNK_SIZE
	var tile_footprint : Array[Vector2i] = []
	for tile in object.tile_footprint:
		tile_footprint.append(tile+global_origin_coords)
	
	for tile in tile_footprint:
		if tile in parent.occupied_tiles or tile in parent.blocked_tiles:
			return false
	
	for tile in tile_footprint:
		parent.occupied_tiles.set(tile, object)
		if object.is_collider:
			parent.blocked_tiles.set(tile, Enums.TerrainType.BLOCKED)
	
	object.position = local_origin_coords * Util.TILE_SIZE
	OBJECTS.set(global_origin_coords, object)
	object.tile_coords = global_origin_coords
	add_child(object)
	return true

func remove_object(tile_coords : Vector2i):
	var object : MapObject = OBJECTS[tile_coords]
	var tile_footprint : Array[Vector2i] = []
	for tile in object.tile_footprint:
		tile_footprint.append(tile_coords + tile)
	for tile in tile_footprint:
		parent.occupied_tiles.erase(tile)
		if object.is_collider:
			parent.blocked_tiles.erase(tile)
	OBJECTS.erase(tile_coords)
	object.queue_free()

func add_entity(entity : Entity, local_origin_coords: Vector2i) -> bool:
	var global_origin_coords : Vector2i = local_origin_coords + chunk_coords * Util.CHUNK_SIZE
	var global_tile_footprint : Array[Vector2i] = []
	
	for tile in entity.tile_footprint:
		global_tile_footprint.append(tile + global_origin_coords)
	
	for global_tile in global_tile_footprint:
		if global_tile in parent.blocked_tiles:
			return false
	entity.position = global_origin_coords * Util.TILE_SIZE + Vector2i(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	entity.tile_coords = global_origin_coords
	entity.initialize(parent.blocked_tiles, parent.interaction_manager)
	ENTITY_LIST.set(entity, false)
	parent.add_child(entity)
	print("~~~~~~~~~~~~~~~")
	print("ADDING ENTITY")
	print("LOCAL :", local_origin_coords, " | GLOBAL :", global_origin_coords, " | CHUNK : ", chunk_coords)
	return true

func remove_entity(entity : Entity) -> bool:
	if entity not in ENTITY_LIST:
		return false
	ENTITY_LIST.erase(entity)
	entity.queue_free()
	return true

func save_self(chunk_manager : ChunkManager, new_chunk_square : Dictionary):
	var chunks = chunk_manager.CHUNKS.duplicate()
	var chunks_to_save = []
	for chunk in chunks:
		if chunk not in new_chunk_square:
			chunks_to_save.append(chunk)
	
	for chunk in chunks_to_save:
		if chunk not in chunk_manager.chunk_save_queue:
			chunk_manager.chunk_save_queue.set(chunk, null)
			
func load_self(chunk_manager : ChunkManager, new_chunk_square : Dictionary):
	var chunks_to_load = []
	for chunk in new_chunk_square:
		if (chunk not in chunk_manager.CHUNKS
			and chunk_manager.chunk_in_bounds(chunk)):
			chunks_to_load.append(chunk)	
	chunk_manager.load_chunks(chunks_to_load)

func get_object_data() -> PackedByteArray:
	var object_data : PackedByteArray = []
	for tile_coords in OBJECTS:
		OBJECTS[tile_coords].encode(object_data)
	return object_data

func get_entity_data() -> PackedByteArray:
	var entity_data : PackedByteArray = []
	for entity in ENTITY_LIST.keys():
		entity.encode(entity_data)
	return entity_data

func get_object_at_tile(tile_coords: Vector2i) -> MapObject:
	if tile_coords in OBJECTS:
		return OBJECTS[tile_coords]
	return null
	
func get_tile_at_tile(tile_coords: Vector2i):
	for map in TILE_MAPS.values():
		var tile_source_id = map.get_cell_source_id(tile_coords)
		if tile_source_id != -1:
			var tile_atlas_coords = map.get_cell_atlas_coords(tile_coords)
			var tile = TileLayerData.new()
			tile.ID = tile_source_id
			tile.atlas_coords = tile_atlas_coords
			tile.tile_coords = tile_coords
			return tile
	return null

func get_tile_id(tile_coords: Vector2i) -> int:
	for map in TILE_MAPS.values():
		return map.get_cell_source_id(tile_coords)
	return -1
