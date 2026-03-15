class_name HoeItem
extends Item

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	if chunk.get_tile_at_tile(tile_coords) == Enums.TileLayer.GRASS:
		pass # ADD FARM TILE
	
func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	pass
