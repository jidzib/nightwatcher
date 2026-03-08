extends Area2D
class_name Chunk
@export var chunk_coords: Vector2i
@onready var GROUND: TileMapLayer = $GroundLayer
#@onready var WATER: TileMapLayer = $WaterLayer
		
@onready var navigation_region : NavigationRegion2D = $NavigationRegion2D

#var navigation_polygon := NavigationPolygon.new()
#var collision_source_data := NavigationMeshSourceGeometryData2D.new()


var OBJECTS : Dictionary = {}

var OBJECT_MAPS : Dictionary = {}
var TILE_MAPS: Dictionary = {}
					
var load_distance: int = 2

var loading := false
var changed = false

@onready var x = $X
@onready var y = $Y

var occupied_tiles : Dictionary = {}


func _ready():
	x.text = str(chunk_coords.x)
	y.text = str(chunk_coords.y)
	
	TILE_MAPS = {
		Enums.TileLayer.GRASS : GROUND,
		#Enums.TileLayer.WATER : WATER
	}
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player entered chunk: ", chunk_coords)
		var chunk_manager = get_parent()
		var new_chunk_square: Dictionary
		for x in range(chunk_coords.x-load_distance, chunk_coords.x+load_distance+1):
			for y in range(chunk_coords.y-load_distance, chunk_coords.y+load_distance+1):
				new_chunk_square.set(Vector2i(x, y), null)
		save_self(chunk_manager, new_chunk_square)
		load_self(chunk_manager, new_chunk_square)

func in_chunk(tile_coords: Vector2i) -> bool:
	if tile_coords.x < 0 or tile_coords.x >= Util.CHUNK_SIZE or tile_coords.y < 0 or tile_coords.y >= Util.CHUNK_SIZE:
		return false
	return true

func get_relative_chunk(tile_coords: Vector2i) -> Vector2i:
	return Vector2i(
		floor(float(tile_coords.x)/Util.CHUNK_SIZE),
		floor(float(tile_coords.y)/Util.CHUNK_SIZE)
	)

func get_tile_in_neighbor(relative_chunk_coords: Vector2i, original_tile_coords: Vector2i) -> Vector2i:
	return original_tile_coords - Vector2i(
											relative_chunk_coords.x * Util.CHUNK_SIZE,
											relative_chunk_coords.y * Util.CHUNK_SIZE
											)
	
func get_tiles_from_footprint(tile_footprint: Array[Vector2i], origin_coords: Vector2i) -> Dictionary:
	var chunk_to_tiles : Dictionary[Vector2i, Array] = {}
	for tile in tile_footprint:
		var relative_chunk_coords : Vector2i = get_relative_chunk(tile+origin_coords)
		var real_chunk_coords = relative_chunk_coords + chunk_coords
		var real_chunk_tile : Vector2i = get_tile_in_neighbor(relative_chunk_coords, tile+origin_coords)
		if real_chunk_coords not in chunk_to_tiles:
			chunk_to_tiles.set(real_chunk_coords, [])
		chunk_to_tiles[real_chunk_coords].append(real_chunk_tile)
	return chunk_to_tiles

func set_tiles_occupied(real_chunk_to_tiles : Dictionary[Vector2i, Array], set_occupied : bool = true):
	for chunk in real_chunk_to_tiles:
		if chunk not in get_parent().CHUNKS:
			continue
		for tile in real_chunk_to_tiles[chunk]:
			if set_occupied:
				get_parent().CHUNKS[chunk].occupied_tiles.set(tile, null)
			else:
				get_parent().CHUNKS[chunk].occupied_tiles.erase(tile)

func add_object(object, origin_coords: Vector2i):
	
	var new_object = object.instantiate()
	
	var real_chunk_to_tiles : Dictionary[Vector2i, Array] = get_tiles_from_footprint(new_object.tile_footprint, origin_coords)
	 
	for chunk in real_chunk_to_tiles:
		if chunk not in get_parent().CHUNKS:
			continue
		
		for tile in real_chunk_to_tiles[chunk]:
			if tile in get_parent().CHUNKS[chunk].occupied_tiles:
				return false
	set_tiles_occupied(real_chunk_to_tiles)
	
	new_object.position = origin_coords*Util.TILE_SIZE + Vector2i(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	new_object.tile_coords = origin_coords
	
	OBJECTS.set(origin_coords, new_object)
	add_child(new_object)
	return true

func remove_object(tile_coords : Vector2i):
	var object = OBJECTS[tile_coords]
	var real_chunk_to_tiles : Dictionary[Vector2i, Array] = get_tiles_from_footprint(object.tile_footprint, tile_coords)
	set_tiles_occupied(real_chunk_to_tiles, false)
	object.queue_free()
	OBJECTS.erase(tile_coords)
	
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
	
func get_objects() -> Array:
	var objects = []
	for key in OBJECTS:
		objects.append(OBJECTS[key].pack())
	return objects

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

func collision_shape_to_outline(object) -> PackedVector2Array:
	var collision_shape = object.hitbox
	var points := PackedVector2Array()
	var e = collision_shape.shape.extents
	points = [
		Vector2(-e.x, -e.y),
		Vector2(e.x, -e.y),
		Vector2(e.x, e.y),
		Vector2(-e.x, e.y)
	]
	
	for i in range(points.size()):
		points[i] = (Vector2(object.tile_coords) * Util.TILE_SIZE) + points[i] + Vector2(Util.TILE_SIZE/2, Util.TILE_SIZE/2) + object.hitbox.position
	return points

func update_navigation_region():
	var navigation_polygon := NavigationPolygon.new()
	#navigation_polygon.make_polygons_from_outlines()
	print("Updating navigation of chunk ", chunk_coords)
	navigation_polygon.add_outline(get_chunk_border_outline())
	navigation_polygon.make_polygons_from_outlines()
	var points_array = []
	for object in OBJECTS.values():
		object.hitbox.self_modulate = Color.GREEN
		var points = collision_shape_to_outline(object)
		
		points.reverse()	
		points_array.append(points)
		if len(points_array) > 0:
			for p in points_array:
				navigation_polygon.add_outline(p)
			points_array = []
	navigation_region.navigation_polygon = navigation_polygon
	navigation_region.bake_navigation_polygon()
	
func get_chunk_border_outline() -> PackedVector2Array:
	var size := (Util.CHUNK_SIZE+1) * Util.TILE_SIZE
	
	return PackedVector2Array([
		Vector2(0, 0),
		Vector2(size, 0),
		Vector2(size, size),
		Vector2(0, size)
	])
	
	
