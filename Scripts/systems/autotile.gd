extends Node
class_name Autotile

@export var parent : MapObject

@export var TILE_MAP_WIDTH : int = 0 # UNUSED
@export var TILE_MAP_HEIGHT : int = 0 # UNUSED
@export var OBJECT_ID : int

@export var BITMASK_TO_ATLAS : Dictionary[int, Vector2i] = {
	6 : Vector2i(0, 0), 7 : Vector2i(1, 0), 3 : Vector2i(2, 0), 0 : Vector2i(3, 0),
	14 : Vector2i(0, 1), 15 : Vector2i(1, 1), 11 : Vector2i(2, 1), 2 : Vector2i(3, 1),
	12 : Vector2i(0, 2), 13 : Vector2i(1, 2), 9 : Vector2i(2, 2), 10 : Vector2i(3, 2),
	4 : Vector2i(0, 3), 5 : Vector2i(1, 3), 1 : Vector2i(2, 3), 8 : Vector2i(3, 3)
}

@export var DIRS : Array[Vector2i] = [
	Vector2i(-1, 0), Vector2i(0, 1),
	Vector2i(1, 0), Vector2i(0, -1)
]

#var SURROUNDINGS : Array[Vector2i] = [
	#Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	#Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0),
	#Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
#]

var atlas_texture : AtlasTexture = AtlasTexture.new()

func _ready():
	atlas_texture.atlas = parent.texture
	
func calculate_bitmask(origin_tile: Vector2i, chunk_coords: Vector2i,
					 	 interaction_manager: InteractionManager) -> int:
	var bitmask : int = 0
	for i in range(len(DIRS)):
		var neighbor : MapObject = interaction_manager.get_object(origin_tile+DIRS[i])
		if neighbor and neighbor.ID == OBJECT_ID:
			bitmask += 2**i
	print("ORIGIN TILE: ", origin_tile)
	print("CHUNK COORDS: ", chunk_coords)
	interaction_manager.get_object(origin_tile).bitmask = bitmask
	return bitmask

func update_surroundings(origin_tile: Vector2i, chunk_coords: Vector2i,
						 interaction_manager: InteractionManager):
	var bitmask : int = calculate_bitmask(origin_tile, chunk_coords, interaction_manager)
	switch_tile(bitmask)
	for dir in DIRS:
		var neighbor_coords : Vector2i = origin_tile + dir
		var neighbor : MapObject = interaction_manager.get_object(neighbor_coords)
		if neighbor and neighbor.ID == OBJECT_ID:
			var neighbor_bitmask : int = calculate_bitmask(neighbor_coords, Util.get_chunk_from_tile(neighbor_coords), interaction_manager)
			neighbor.autotile.switch_tile(neighbor_bitmask)			

func switch_tile(bitmask: int):
	var atlas_coords : Vector2i = BITMASK_TO_ATLAS[bitmask]
	atlas_texture.region = Rect2(atlas_coords.x*Util.TILE_SIZE, atlas_coords.y*Util.TILE_SIZE,
							 Util.TILE_SIZE, Util.TILE_SIZE)
	parent.sprite.texture = atlas_texture
