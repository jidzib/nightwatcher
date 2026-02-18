extends Node2D
class_name MapContainer
#
#@onready var BREAKABLE : BreakableMap = $BreakableMap
#@onready var CROP : CropMap = $CropMap
#@onready var GENERATOR : MapGenerator = $MapGenerator
#@onready var TILE_MAP : Node2D = $Tiles
#@onready var CHUNKS : Node2D = $Chunks
#
#@export var MAP_ID : int = 1
#
#var OBJECT_TYPES : Dictionary = { Enums.ObjectCategory.BREAKABLE : BREAKABLE,
								  #Enums.ObjectCategory.CROP : CROP }
								#
#var BREAKABLE_TO_RESOURCE : Dictionary[int, BreakableResource] = {
	#Enums.BreakableType.TREE : load("res://resources/objects/tree_resource.tres"),
	#Enums.BreakableType.ROCK : load("res://resources/objects/rock_resource.tres")
#}
#var CROP_TO_RESOURCE : Dictionary[int, CropResource] = {
	#Enums.CropType.SUNFLOWER : load("res://resources/crops/sunflower_crop.tres")
#}
#
#var CATEGORY_TO_DICT : Dictionary[int, Dictionary] = {
	#Enums.ObjectCategory.CROP : CROP_TO_RESOURCE,
	#Enums.ObjectCategory.BREAKABLE : BREAKABLE_TO_RESOURCE
#}
#var CATEGORY_TO_SCENE : Dictionary[int, Resource] = {
	#Enums.ObjectCategory.BREAKABLE : load("res://Scenes/environment/objects/BreakableObject.tscn"),
	#Enums.ObjectCategory.CROP : load("res://Scenes/environment/objects/CropObject.tscn")
#}
#
#var BREAKABLE_TO_SCENE : Dictionary[int, Resource] = {
	#Enums.BreakableType.TREE : load("res://Scenes/environment/objects/TreeObject.tscn"),
	#Enums.BreakableType.ROCK : load("res://Scenes/environment/objects/RockObject.tscn")
#}
#
#var CATEGORY_TO_SUBCATEGORY : Dictionary[int, Dictionary] = {
	#Enums.ObjectCategory.BREAKABLE : BREAKABLE_TO_SCENE
#}
#
#var TILE_ID_TO_LAYER : Dictionary[int, TileMapLayer] = {
	#Enums.TileLayer.GRASS : $Tiles/GrassLayer,
	#Enums.TileLayer.FARM : $Tiles/FarmLayer
#}
#
#var chunks : Dictionary[Vector2i, Chunk] = {}
#var player: Player
#
#func _ready():
	#player = get_node("Player")
	#player.current_map = self
	#
	##for obj_type in OBJECT_TYPES:
		##OBJECT_TYPES[obj_type].parent = self
	#CROP.parent = self
	#TILE_MAP.parent = self
	#TILE_ID_TO_LAYER.set(Enums.TileLayer.GRASS, TILE_MAP.GRASS)
	#TILE_ID_TO_LAYER.set(Enums.TileLayer.FARM, TILE_MAP.FARM)
	#
	#OBJECT_TYPES.set(Enums.ObjectCategory.BREAKABLE, BREAKABLE)
	#OBJECT_TYPES.set(Enums.ObjectCategory.CROP, CROP)
	##GENERATOR.generate_world(self)
	##for x in range(-2, 2):
		##for y in range(-2, 2):
			##GENERATOR.generate_chunk(Vector2i(x, y), self)
	#
	#var world_data = WorldData.new()
	#var map_data = MapData.new()
	#world_data.maps.set(MAP_ID, map_data)
	#ResourceSaver.save(world_data, "res://resources/data/world_data.tres")
	##CATEGORY_TO_SUBCATEGORY[object_data.object.object_category][object_data.object.category_id].instantiate()
#func search(tile: Vector2i, obj_type):
	#if OBJECT_TYPES[obj_type].objects.has(tile):
		#return OBJECT_TYPES[obj_type].objects[tile]
	#return null                
#
#func lookup(tile: Vector2i) -> Array:
	#var on_tile = []
	#for obj_type in OBJECT_TYPES:
		#if OBJECT_TYPES[obj_type].objects.has(tile):
			#on_tile.append(OBJECT_TYPES[obj_type].objects[tile])
	#return on_tile
#
#func get_tile_data(tile: Vector2i) -> Array:
	#var on_tile = []
	#var ids: PackedByteArray
	#var atlas_x: PackedByteArray
	#var atlas_y: PackedByteArray
	##var chunk_coords: Vector2i = Vector2i(floori(tile.x/Util.CHUNK_SIZE), floori(tile.y/Util.CHUNK_SIZE))
	#var local_coords: Vector2i = Vector2i(posmod(tile.x, Util.CHUNK_SIZE), posmod(tile.y, Util.CHUNK_SIZE))
	#for ID in TILE_ID_TO_LAYER:
		#var layer = TILE_ID_TO_LAYER[ID].get_cell_tile_data(tile)
		#if layer == null:
			#continue		
		#var atlas_coords = TILE_ID_TO_LAYER[ID].get_cell_atlas_coords(tile)
		#var curr_tile: Array = [local_coords.x, local_coords.y, ID, atlas_coords.x, atlas_coords.y]
		#on_tile.append(curr_tile)
		#
	#return on_tile
#func reset_objects():
	#for type in OBJECT_TYPES:
		#OBJECT_TYPES[type].objects = {}
		#for child in OBJECT_TYPES[type].get_children():
			#child.free()
#
#func reset_tilemaps():
	#for ID in TILE_ID_TO_LAYER:
		#TILE_ID_TO_LAYER[ID].clear()
#
#func save_map_to_world():
	#SaveData.save_world.emit(self)
#
#func load_by_chunk(world_data: WorldData):
	#for child in CHUNKS.get_children():
		#child.queue_free()
	#for x in range(-1, 2):
		#for y in range(-1, 2):
			#load_chunk(Vector2i(x, y))
	#
#func load_map_from_world(world_data: WorldData):
	#reset_objects()
	#reset_tilemaps()
	#
	#var map_data = world_data.maps[MAP_ID]
	#for chunk_coords in map_data.chunks:
		#var chunk_data = map_data.chunks[chunk_coords]
		#for object_coords in chunk_data.objects:
			#var object_data_array = chunk_data.objects[object_coords]
			#for object_data in object_data_array:
				#var map_object = CATEGORY_TO_SUBCATEGORY[object_data.object.CATEGORY][object_data.object.SUBCATEGORY].instantiate()
				#map_object.global_position = Vector2((chunk_coords.x*Util.CHUNK_SIZE + object_coords.x)*Util.TILE_SIZE+8,
													#(chunk_coords.y*Util.CHUNK_SIZE + object_coords.y)*Util.TILE_SIZE+8)			
				#OBJECT_TYPES[object_data.object.CATEGORY].add_child(map_object)						
		#for i in range(chunk_data.tile_ids.size()):
			#TILE_ID_TO_LAYER[chunk_data.tile_ids[i]].set_cell(Vector2((chunk_coords.x*Util.CHUNK_SIZE + chunk_data.pos_x[i]),
												#(chunk_coords.y*Util.CHUNK_SIZE + chunk_data.pos_y[i])),
												#0,
												#Vector2i(chunk_data.tile_atlas_x[i], chunk_data.tile_atlas_y[i]))
			##var tile_data_array = chunk_data.tiles[tile_coords]
			##for tile_data in tile_data_array:
				##TILE_ID_TO_LAYER[tile_data[0]].set_cell(Vector2((chunk_coords.x*Util.CHUNK_SIZE + tile_coords.x),
													##(chunk_coords.y*Util.CHUNK_SIZE + tile_coords.y)), 
											##0, 
											##tile_data[1])
				## the 0 is source_id, need to make TileLayerData include it in the future
#
#func save_chunk(chunk_coords: Vector2i):
	#var world_data: WorldData = ResourceLoader.load("res://resources/data/world_data.tres")
	#var map_data: MapData = world_data.maps[MAP_ID]
	#var new_chunk: ChunkData = ChunkData.new()
	#
	#for x in range(Util.CHUNK_SIZE):
		#for y in range(Util.CHUNK_SIZE):
			#var tile_coords = Vector2i(chunk_coords.x*Util.CHUNK_SIZE + x, chunk_coords.y*Util.CHUNK_SIZE + y)
			#var tiles_to_save = get_tile_data(tile_coords)
			#for tile in tiles_to_save:
				#new_chunk.pos_x.append(tile[0])
				#new_chunk.pos_y.append(tile[1])
				#new_chunk.tile_ids.append(tile[2])
				#new_chunk.tile_atlas_x.append(tile[3])
				#new_chunk.tile_atlas_y.append(tile[4])
			#var objects_at_tile = lookup(tile_coords)
			#if objects_at_tile.is_empty():
				#continue
			#var objects_to_save = []
			#for object in objects_at_tile:
				#var object_data = ObjectData.new()
				#object_data.object = object.object
				#objects_to_save.append(object_data)
			#new_chunk.objects.set(Vector2i(x, y), objects_to_save)
	#
	#return new_chunk
	##map_data.chunks.set(chunk_coords, new_chunk)
	#
	##ResourceSaver.save(world_data, "res://resources/data/world_data.tres")			
#
#func load_chunk(chunk_coords: Vector2i):
	#print("Loading chunk: ", chunk_coords)
	#var world_data: WorldData = ResourceLoader.load("res://resources/data/world_data.tres")
	#var map_data: MapData = world_data.maps[MAP_ID]
	#var chunk_data: ChunkData = map_data.chunks[chunk_coords]
	#var chunk = Chunk.new()
	#CHUNKS.add_child(chunk)
	#for i in range(len(chunk_data.tile_ids)):
		#var id = chunk_data.tile_ids[i]
		#var atlas_coords = Vector2i(chunk_data.tile_atlas_x[i], chunk_data.tile_atlas_y[i])
		#var tile_coords = Vector2i(chunk_data.pos_x[i], chunk_data.pos_y[i])
		#
		#chunk.TILE_ID_TO_LAYER[id].set_cell(tile_coords, 0, atlas_coords)	
		#
	##for tile_coords in chunk_data.objects:
		##for object_data in chunk_data.objects[tile_coords]:
			##var map_object = chunk.CATEGORY_TO_SUBCATEGORY[object_data.object.CATEGORY][object_data.object.SUBCATEGORY].instantiate()
			##map_object.position = tile_coords
			##print(chunk.OBJECT_TYPES)
			##chunk.OBJECT_TYPES[object_data.object.CATEGORY].add_child(map_object)
			#
							#
#func _on_tree_entered() -> void:
	#SaveData.save_data.connect(save_map_to_world)
	#SaveData.load_world.connect(load_by_chunk)
#func _on_tree_exited() -> void:
	#SaveData.save_data.disconnect(save_map_to_world)
	#SaveData.load_world.disconnect(load_by_chunk)
