extends Item
class_name Placeable

@export var map_object : String
@export var can_place_on : Array[String] = []

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	if !can_place(chunk, tile_coords):
		return
	var object = References.OBJECTS[Enums.ObjectType[map_object]]
	if chunk.add_object(object, tile_coords):
		player.inventory.remove_item(self, 1)
	
func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	pass

func can_place(chunk: Chunk, tile_coords: Vector2i) -> bool:
	var tile : TileLayerData = chunk.get_tile_at_tile(tile_coords)
	if !tile or !can_place_on:
		return false
	for tile_id in can_place_on:
		if Enums.TileLayer[tile_id] == tile.ID:
			return true
	return false
