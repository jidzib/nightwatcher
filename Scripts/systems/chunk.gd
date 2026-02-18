extends Area2D
class_name Chunk
@export var chunk_coords: Vector2i
@onready var GRASS: TileMapLayer = $GrassLayer
@onready var FARM: TileMapLayer = $FarmLayer
@onready var WATER: TileMapLayer = $WaterLayer
@onready var BREAKABLE : BreakableMap = $BreakableMap
#@onready var CROP : CropMap = $CropMap
			
var OBJECT_MAPS : Dictionary = {}					
var load_distance: int = 1

var changed = false

func _ready():
	OBJECT_MAPS = { Enums.ObjectCategory.BREAKABLE : BREAKABLE}
	
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

func add_object(category: int, object, tile_coords: Vector2i):
	# Get the instance of the category to add to
	# Actual adding of the object can be done here or in the given container 
	# ^ would include adding to its 'objects' dictionary and adding the object as a child
	var new_object = object.instantiate()
	new_object.position = tile_coords*Util.TILE_SIZE + Vector2i(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	new_object.tile_coords = tile_coords
	OBJECT_MAPS[category].objects.set(tile_coords, new_object)
	OBJECT_MAPS[category].add_child(new_object)
	# Potential "change" logic for more efficient saving <- probably hold off on this
	pass

func save_self(chunk_manager : ChunkManager, new_chunk_square : Dictionary):
	var chunks = chunk_manager.CHUNKS.duplicate()
	var chunks_to_save = []
	for chunk in chunks:
		if chunk not in new_chunk_square:
			chunks_to_save.append(chunk)
	
	#chunk_manager.save_chunks(chunks_to_save)
	for chunk in chunks_to_save:
		chunk_manager.save_chunk(chunk)
		chunk_manager.offload_chunk(chunk)	
			
func load_self(chunk_manager : ChunkManager, new_chunk_square : Dictionary):
	var chunks_to_load = []
	for chunk in new_chunk_square:
		if (chunk not in chunk_manager.CHUNKS
			and chunk_manager.chunk_in_bounds(chunk)):
			chunks_to_load.append(chunk)
	
	chunk_manager.load_chunks(chunks_to_load)
	
func get_objects() -> Array:
	var objects = []
	for key in OBJECT_MAPS:
		for coords in OBJECT_MAPS[key].objects:
			objects.append(OBJECT_MAPS[key].objects[coords].pack())
	return objects

func get_object_at_tile(tile_coords: Vector2i) -> MapObject:
	for map in OBJECT_MAPS.values():
		if tile_coords in map.objects:
			return map.objects[tile_coords]
	return null
