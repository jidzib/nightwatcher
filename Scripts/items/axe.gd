extends Item
class_name AxeItem

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player):
	var object = world.chunk_manager.interaction_manager.get_selected_object()
	if object and object.ID == Enums.ObjectType.TREE:
		object.hit(1)

func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player):
	pass

func set_type():
	type = Enums.ItemType.AXE
