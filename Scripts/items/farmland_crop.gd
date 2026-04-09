extends PlaceableItem
class_name FarmlandCropItem

func use(world: World, tile_coords: Vector2i, player: Player) -> void:
	var chunk_coords : Vector2i = Util.get_chunk_from_tile(tile_coords)
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	if tile_coords not in chunk.OBJECTS:
		return
		
	var obj = player.interaction_manager.get_selected_object(player)
	if !is_farmland(obj) or !obj.can_plant():
		return
		
	obj.plant(References.OBJECTS[Enums.ObjectType[map_object]].instantiate())
	player.inventory.remove_item(self, 1)
	
func alt_use(world: World, tile_coords: Vector2i, player: Player) -> void:
	pass
	
func is_farmland(obj: MapObject) -> bool:
	if obj and obj.ID == Enums.ObjectType.FARMLAND:
			return true
	return false
