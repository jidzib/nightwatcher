extends Item
class_name Placeable

@export var map_object : String

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	var object = References.OBJECTS[Enums.ObjectType[map_object]]
	if chunk.add_object(object, tile_coords):
		player.inventory.remove_item(self, 1)
	
func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	pass
