extends Node2D
class_name MapContainer

@onready var BREAKABLE : BreakableMap = $BreakableMap
@onready var CROP : CropMap = $CropMap
@onready var GENERATOR : MapGenerator = $MapGenerator
@onready var TILE_MAP : Node2D = $Tiles
@onready var GRASS : TileMapLayer = $Tiles/GrassLayer

var OBJECT_TYPES : Dictionary = { Enums.ObjectType.BREAKABLE : BREAKABLE,
								  Enums.ObjectType.CROP : CROP }

func _ready():
	
	TILE_MAP.parent = self
	
	OBJECT_TYPES.set(Enums.ObjectType.BREAKABLE, BREAKABLE)
	OBJECT_TYPES.set(Enums.ObjectType.CROP, CROP)
	GENERATOR.generate_world(self)

func search(tile: Vector2i, obj_type):
	if OBJECT_TYPES[obj_type].objects.has(tile):
		return OBJECT_TYPES[obj_type].objects[tile]
	return null                

func lookup(tile: Vector2i) -> Array:
	var on_tile = []
	for obj_type in OBJECT_TYPES:
		if OBJECT_TYPES[obj_type].objects.has(tile):
			on_tile.append(OBJECT_TYPES[obj_type].objects[tile])
	print(on_tile)
	return on_tile
	
	
