extends Node2D

@onready var GRASS: TileMapLayer = $GrassLayer
var GRASS_TERRAIN_SET: int = 0
var GRASS_TERRAIN_ID: int = 0

@onready var FARM: TileMapLayer = $FarmLayer
var FARM_TERRAIN_SET: int = 0
var FARM_TERRAIN_ID: int = 0

var parent: MapContainer

func _ready():
	pass	

func till_at_world_pos(player_pos: Vector2, range: int):
	var tile := GRASS.local_to_map(get_global_mouse_position())
	
	if (GRASS.get_cell_tile_data(tile) == null or
	FARM.get_cell_tile_data(tile) != null or
	tile_distance(tile, pos_to_tile(player_pos)) > range or
	not parent.lookup(tile).is_empty()
	):
		return 
	
	var tiles: Array[Vector2i] = []
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			if FARM.get_cell_tile_data(tile + Vector2i(x, y)) != null:	
				tiles.append(tile + Vector2i(x, y))
	
	FARM.set_cells_terrain_connect(
		[tile],
		FARM_TERRAIN_SET,
		FARM_TERRAIN_ID
	)
	update_surrounding(tile)

func update_surrounding(tile: Vector2i):
	var tiles: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if FARM.get_cell_tile_data(tile + Vector2i(x, y)) != null:	
				tiles.append(tile + Vector2i(x, y))
	FARM.set_cells_terrain_connect(
		tiles,
		FARM_TERRAIN_SET,
		FARM_TERRAIN_ID
	)

func pos_to_tile(world_pos: Vector2) -> Vector2i:
	return GRASS.local_to_map(world_pos)
	
func tile_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)
