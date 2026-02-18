extends Node

var TILE_SIZE : int = 16
var CHUNK_SIZE : int = 32
var DIR : String = "user://worlds/"

func get_chunk_from_world(world_pos: Vector2) -> Vector2i:
	var tile: Vector2i = get_tile_from_world(world_pos)
	return Vector2i(
		int(floor(float(tile.x) / CHUNK_SIZE)),
		int(floor(float(tile.y) / CHUNK_SIZE))
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
