extends Node

var TILE_SIZE : int = 16
var CHUNK_SIZE : int = 32
var DIR : String = "user://worlds/"

var BOUNDS : Vector2i

var ENTITY_NAVIGATION_RANGE : int = 64

var DIRECTIONS : Array[Vector2i] = [
	Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)
]


func get_local_from_global_tile(tile_coords: Vector2i) -> Vector2i:
	var chunk_coords : Vector2i = get_chunk_from_tile(tile_coords)
	return tile_coords - (chunk_coords * CHUNK_SIZE)

func get_chunk_from_world(world_pos: Vector2) -> Vector2i:
	var tile: Vector2i = get_tile_from_world(world_pos)
	return Vector2i(
		int(floor(float(tile.x) / CHUNK_SIZE)),
		int(floor(float(tile.y) / CHUNK_SIZE))
	)

func get_chunk_from_tile(tile_coords: Vector2i) -> Vector2i:
	return Vector2i(
		int(floor(float(tile_coords.x) / CHUNK_SIZE)),
		int(floor(float(tile_coords.y) / CHUNK_SIZE))
	)

func get_tile_from_world(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(floor(world_pos.x / TILE_SIZE)),
		int(floor(world_pos.y / TILE_SIZE))
	)
	
func get_local_tile_from_world(world_pos: Vector2) -> Vector2i:
	var tile: Vector2i = get_tile_from_world(world_pos)
	return Vector2i(
		posmod(tile.x, CHUNK_SIZE),
		posmod(tile.y, CHUNK_SIZE)
		)

func get_tile_distance(tile1_coords: Vector2i, 
					   tile1_chunk: Vector2i, tile2_coords: Vector2i,
					   tile2_chunk: Vector2i) -> float:
	var tile1_world : Vector2 = tile1_chunk * Util.CHUNK_SIZE + tile1_coords
	var tile2_world : Vector2 = tile2_chunk * Util.CHUNK_SIZE + tile2_coords

	return tile1_world.distance_to(tile2_world)

func switch_scene(new_scene: Node) -> void:
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
