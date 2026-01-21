extends Node2D
class_name MapObject

var TILE_SIZE = 16
var obj_type
var INTERACTABLE: Dictionary = {}
var map_ref: MapContainer


func _ready():
	initialize_to_map()
	
func initialize_to_map():
	var tile = local_to_map(global_position)
	set_type()
	set_interactables()
	map_ref = get_parent().get_parent()
	map_ref.OBJECT_TYPES[obj_type].register(tile, self)

func local_to_map(coords: Vector2) -> Vector2i:
	return Vector2i(floor(coords.x/TILE_SIZE), floor(coords.y/TILE_SIZE))

func can_interact_with(item: Item) -> bool:
	if INTERACTABLE.has(item):
		return true
	return false

func set_type():
	pass	
func set_interactables():
	pass
