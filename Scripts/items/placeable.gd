extends Item
class_name PlaceableItem

@export var map_object : String
@export var can_place_on : Array[String] = []

func use(world: World, tile_coords: Vector2i, player: Player) -> void:
	var chunk_coords : Vector2i = Util.get_chunk_from_tile(tile_coords)
	var local_coords : Vector2i = Util.get_local_from_global_tile(tile_coords)
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	var object = References.OBJECTS[Enums.ObjectType[map_object]].instantiate()
	if chunk.add_object(object, local_coords):
		player.inventory.remove_item(self, 1)
	else:
		object.queue_free()
	
func alt_use(world: World, tile_coords: Vector2i, player: Player) -> void:
	pass
