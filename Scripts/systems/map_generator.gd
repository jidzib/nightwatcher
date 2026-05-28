extends Node2D
class_name MapGenerator

@export var noise_texture: NoiseTexture2D
@export var tree_noise_texture: NoiseTexture2D

@export var temperature_texture: NoiseTexture2D
@export var moisture_texture: NoiseTexture2D
@export var height_texture: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var width: int
var height: int

var BIOMES : Dictionary[Array, Biomes] = {
	[Temperatures.COLD, Moistures.DRY] : Biomes.SNOW,
	[Temperatures.COLD, Moistures.NORMAL] : Biomes.SNOW,
	[Temperatures.COLD, Moistures.WET] : Biomes.SNOW,
	
	[Temperatures.TEMPERATE, Moistures.DRY] : Biomes.FOREST,
	[Temperatures.TEMPERATE, Moistures.NORMAL] : Biomes.FOREST,
	[Temperatures.TEMPERATE, Moistures.WET] : Biomes.FOREST,
	
	[Temperatures.HOT, Moistures.DRY] : Biomes.DESERT,
	[Temperatures.HOT, Moistures.NORMAL] : Biomes.DESERT,
	[Temperatures.HOT, Moistures.WET] : Biomes.JUNGLE
}

var GRASS_ID: int = 0
var WATER_ID: int = 1
var SNOW_ID : int = 2
var SAND_ID : int = 3
var JUNGLE_ID : int = 4

var CHUNK = load("res://Scenes/systems/Chunk.tscn")

enum Biomes {
	FOREST,
	SNOW,
	DESERT,
	JUNGLE
}

enum Temperatures {
	COLD,
	TEMPERATE,
	HOT
}

enum Moistures {
	DRY,
	NORMAL,
	WET
}

func _ready():
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise
	width = noise_texture.width
	height = noise_texture.height
	

func _generate_chunk(chunk_coords: Vector2i, chunk_manager: ChunkManager) -> void:
	print("GENERATING CHUNK")
	var pos : Vector2 = chunk_coords * Util.CHUNK_SIZE * Util.TILE_SIZE
	var chunk = Chunk.new_chunk(chunk_coords, pos, chunk_manager)
	chunk_manager.add_child(chunk)
	chunk_manager.CHUNKS.set(chunk_coords, chunk)
	
	var forest_cells: Array[Vector2i] = []
	var snow_cells: Array[Vector2i] = []
	var desert_cells: Array[Vector2i] = []
	var jungle_cells: Array[Vector2i] = []
	var edge_cells : Array[Vector2i] = []
	var water_cells : Array[Vector2i] = []
	var min_noise : float = float("inf")
	var max_noise : float = float("-inf")
	
	for x in range(-1, Util.CHUNK_SIZE+1):
		for y in range(-1, Util.CHUNK_SIZE+1):
			var tile_coords : Vector2i = Vector2i(chunk_coords.x * Util.CHUNK_SIZE + x,
													chunk_coords.y * Util.CHUNK_SIZE + y)
			var temp_noise : float = ((temperature_texture.noise.get_noise_2d(tile_coords.x, tile_coords.y)
										+ 1.0 ) / 2.0)
			var moisture_noise : float = ((moisture_texture.noise.get_noise_2d(tile_coords.x, tile_coords.y)
										+ 1.0 ) / 2.0)
			var h : float = ((height_texture.noise.get_noise_2d(tile_coords.x, tile_coords.y)
										+ 1.0 ) / 2.0)
			
			var biome : Biomes
			var local_coords : Vector2i = Vector2i(x, y)
			
			var temperature : int = get_temperature(temp_noise)
			var moisture : int = get_moisture(moisture_noise)
			
			if h < 0.4:
				water_cells.append(local_coords)
			else:
				biome = BIOMES[[temperature, moisture]]
				
				if biome == Biomes.FOREST:
					forest_cells.append(local_coords)
				elif biome == Biomes.DESERT:
					desert_cells.append(local_coords)
				elif biome == Biomes.JUNGLE:
					jungle_cells.append(local_coords)
				elif biome == Biomes.SNOW:
					snow_cells.append(local_coords)
		
			if x == -1 or y == -1 or x == Util.CHUNK_SIZE or y == Util.CHUNK_SIZE:
				edge_cells.append(Vector2i(x, y))
				continue
			
			if h > 0.4:
				var r : float = randf()
				if biome == Biomes.JUNGLE:
					if r < 0.2:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.JUNGLE_TREE].instantiate(),
									 Vector2i(x, y))
					elif r < 0.4:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.FOLIAGE].instantiate(),
									 Vector2i(x, y))
					elif r < 0.41:
						chunk.add_entity(References.ENTITIES[Enums.EntityType.RED_PANDA].instantiate(),
										Vector2i(x, y))
					elif r < 0.55:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.BAMBOO_TREE].instantiate(),
									 Vector2i(x, y))
				elif biome == Biomes.FOREST:
					if r < 0.04:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.FOREST_TREE].instantiate(),
									 Vector2i(x, y))
					elif r < 0.041:
						chunk.add_entity(References.ENTITIES[Enums.EntityType.BUNNY].instantiate(),
								Vector2i(x, y))
					elif r < 0.08:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.FOLIAGE].instantiate(),
									 Vector2i(x, y))
				elif biome == Biomes.DESERT:
					if r < 0.04:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.CACTUS].instantiate(),
									Vector2i(x, y))
				elif biome == Biomes.SNOW:
					if r < 0.04:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.SNOW_TREE].instantiate(),
									Vector2i(x, y))
					elif r < 0.041:
						chunk.add_entity(References.ENTITIES[Enums.EntityType.SNOW_LEOPARD].instantiate(),
								Vector2i(x, y))	
					elif r < 0.06:
						chunk.add_object(References.OBJECTS[Enums.ObjectType.ROCK].instantiate(),
									 Vector2i(x, y))

	chunk.GROUND.set_cells_terrain_connect(forest_cells, 0, GRASS_ID)
	chunk.GROUND.set_cells_terrain_connect(water_cells, 0, WATER_ID)
	chunk.GROUND.set_cells_terrain_connect(snow_cells, 0, SNOW_ID)
	chunk.GROUND.set_cells_terrain_connect(desert_cells, 0, SAND_ID)
	chunk.GROUND.set_cells_terrain_connect(jungle_cells, 0, JUNGLE_ID)
	for cell in edge_cells:
		chunk.GROUND.erase_cell(cell)	
				
#func generate_chunk(chunk_coords: Vector2i, chunk_manager: ChunkManager):
	#print("Generating chunk: ", chunk_coords)
	#var pos : Vector2 = chunk_coords*Util.CHUNK_SIZE*Util.TILE_SIZE
	#var chunk = Chunk.new_chunk(chunk_coords, pos, chunk_manager)
	#chunk_manager.add_child(chunk)
	#chunk_manager.CHUNKS.set(chunk_coords, chunk)
	#var water_cells = []
	#var grass_cells = []
	#var edge_cells = []
	#for x in range(-1, Util.CHUNK_SIZE+1):
		#for y in range(-1, Util.CHUNK_SIZE+1):
			#var tile_coords = Vector2i(chunk_coords.x*Util.CHUNK_SIZE+x,
											   #chunk_coords.y*Util.CHUNK_SIZE+y)
			#var noise_val = noise.get_noise_2d(tile_coords.x, tile_coords.y)
			#var tree_noise_val = tree_noise.get_noise_2d(tile_coords.x, tile_coords.y)
			#if noise_val > -0.4:
				#grass_cells.append(Vector2i(x, y)) 
			#else:
				#water_cells.append(Vector2i(x, y))	
				#
			#if x == -1 or y == -1 or x == Util.CHUNK_SIZE or y == Util.CHUNK_SIZE:
				#edge_cells.append(Vector2i(x, y))
				#continue
				#
			#if noise_val > -0.4 and chunk_manager.rng.randf() > 0.95:
				#chunk.add_object(References.OBJECTS[Enums.ObjectType.TREE].instantiate(),
								 #Vector2i(x, y))
								#
			#elif noise_val > -0.4 and chunk_manager.rng.randf() > 0.95:
				#chunk.add_object(References.OBJECTS[Enums.ObjectType.ROCK].instantiate(),
								#Vector2i(x, y))
			#elif noise_val > -0.4 and chunk_manager.rng.randf() > 0.80:
				#chunk.add_object(References.OBJECTS[Enums.ObjectType.FOLIAGE].instantiate(),
								#Vector2i(x, y))
				#
	#chunk.GROUND.set_cells_terrain_connect(grass_cells, 0, GRASS_ID)
	#chunk.GROUND.set_cells_terrain_connect(water_cells, 0, WATER_ID)
	#for cell in edge_cells:
		#chunk.GROUND.erase_cell(cell)
		
func set_size(size : int) -> void:
	noise_texture.width = size
	noise_texture.height = size
	tree_noise_texture.width = size
	tree_noise_texture.height = size

	temperature_texture.width = size
	moisture_texture.width = size	
	temperature_texture.height = size
	moisture_texture.height = size
	height_texture.width = size
	height_texture.height = size

func set_seed(seed: int) -> void:
	print("NOISE TEXTURE: ", noise_texture)
	print("TEMPERATURE NOISE TEXTURE: ", temperature_texture)
	noise_texture.noise.seed = seed
	tree_noise_texture.noise.seed = seed
	temperature_texture.noise.seed = seed
	moisture_texture.noise.seed = seed
	height_texture.noise.seed = seed

func get_temperature(_temperature: float) -> Temperatures:
	if _temperature < 0.4:
		return Temperatures.COLD
	elif _temperature < 0.6:
		return Temperatures.TEMPERATE
	else:
		return Temperatures.HOT

func get_moisture(_moisture: float) -> Moistures:
	if _moisture < 0.35:
		return Moistures.DRY
	elif _moisture < 0.5:
		return Moistures.NORMAL
	else:
		return Moistures.WET
