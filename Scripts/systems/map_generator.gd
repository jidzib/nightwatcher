extends Node2D
class_name MapGenerator

@export var noise_texture: NoiseTexture2D
@export var tree_noise_texture: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var width: int
var height: int

var GRASS_ID: int = 0
var WATER_ID: int = 1

var CHUNK = load("res://Scenes/systems/Chunk.tscn")

func _ready():
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise
	width = noise_texture.width
	height = noise_texture.height
	

func generate_chunk(chunk_coords: Vector2i, chunk_manager: ChunkManager):
	print("Generating chunk: ", chunk_coords)
	var chunk = CHUNK.instantiate()
	chunk.position = chunk_coords*Util.CHUNK_SIZE*Util.TILE_SIZE
	chunk_manager.add_child(chunk)
	chunk.chunk_coords = chunk_coords
	chunk_manager.CHUNKS.set(chunk_coords, chunk)
	var water_cells = []
	var grass_cells = []
	var edge_cells = []
	for x in range(-1, Util.CHUNK_SIZE+1):
		for y in range(-1, Util.CHUNK_SIZE+1):
			var tile_coords = Vector2i(chunk_coords.x*Util.CHUNK_SIZE+x,
											   chunk_coords.y*Util.CHUNK_SIZE+y)
			var noise_val = noise.get_noise_2d(tile_coords.x, tile_coords.y)
			var tree_noise_val = tree_noise.get_noise_2d(tile_coords.x, tile_coords.y)
			if noise_val > -0.4:
				grass_cells.append(Vector2i(x, y))
			else:
				water_cells.append(Vector2i(x, y))	
				
			if x == -1 or y == -1 or x == Util.CHUNK_SIZE or y == Util.CHUNK_SIZE:
				edge_cells.append(Vector2i(x, y))
				continue
				
			if noise_val > -0.4 and chunk_manager.rng.randf() > 0.95:
				chunk.add_object(References.OBJECTS[Enums.ObjectType.TREE],
								 Vector2i(x, y))
								
			elif noise_val > -0.4 and chunk_manager.rng.randf() > 0.95:
				chunk.add_object(References.OBJECTS[Enums.ObjectType.ROCK],
								Vector2i(x, y))
				
	chunk.GROUND.set_cells_terrain_connect(grass_cells, 0, GRASS_ID)
	chunk.GROUND.set_cells_terrain_connect(water_cells, 0, WATER_ID)
	for cell in edge_cells:
		chunk.GROUND.erase_cell(cell)

func set_size(size : int):
	noise_texture.width = size
	noise_texture.height = size
	tree_noise_texture.width = size
	tree_noise_texture.height = size
	
