extends Node2D
class_name MapGenerator

@export var noise_texture: NoiseTexture2D
@export var tree_noise_texture: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var width: int
var height: int

var TILE_SIZE: int = 16

@onready var grass_tilemap = $GrassLayer
var GRASS_ID: int = 0
var GRASS: Vector2i = Vector2i(0, 0)
var WATER_ID: int = 1

#var EMPTY_OBJECT = load("res://MapObject.tscn")
#var BREAKABLE_OBJECT = load("res://Scenes/environment/objects/BreakableObject.tscn")

var TREE = load("res://Scenes/environment/objects/Tree.tscn")
#var ROCK = load("res://Scenes/environment/objects/RockObject.tscn")

var CHUNK = load("res://Chunk.tscn")

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
	for x in range(Util.CHUNK_SIZE):
		for y in range(Util.CHUNK_SIZE):
			var tile_coords = Vector2i(chunk_coords.x*Util.CHUNK_SIZE+x,
											   chunk_coords.y*Util.CHUNK_SIZE+y)
			var noise_val = noise.get_noise_2d(tile_coords.x, tile_coords.y)
			var tree_noise_val = tree_noise.get_noise_2d(tile_coords.x, tile_coords.y)
			if noise_val > -0.4:
				if tree_noise_val > 0.3 and randf() > 0.3:
					chunk.add_object(Enums.ObjectCategory.BREAKABLE,
									 References.OBJECTS[Enums.ObjectType.TREE],
									 Vector2i(x, y))
									
				elif tree_noise_val < -0.3 and randf() > 0.3:
					chunk.add_object(Enums.ObjectCategory.BREAKABLE,
									References.OBJECTS[Enums.ObjectType.ROCK],
									Vector2i(x, y))
									
				chunk.GRASS.set_cell(Vector2i(x, y), GRASS_ID, GRASS)
			else:
				chunk.WATER.set_cell(Vector2i(x, y), GRASS_ID, GRASS)
