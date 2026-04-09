extends Item
class_name PlaceableItem

@export var map_object : String
@export var can_place_on : Array[String] = []

func use(world: World, tile_coords: Vector2i, player: Player) -> void:
	var chunk_coords : Vector2i = Vector2i(
		floor(tile_coords.x / Util.CHUNK_SIZE),
		floor(tile_coords.y / Util.CHUNK_SIZE)
	)
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	var object = References.OBJECTS[Enums.ObjectType[map_object]].instantiate()
	if chunk.add_object(object, tile_coords):
		player.inventory.remove_item(self, 1)
	else:
		object.queue_free()
	
func alt_use(world: World, tile_coords: Vector2i, player: Player) -> void:
	pass
