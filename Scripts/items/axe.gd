extends Item
class_name AxeItem

func use(world, chunk_coords, tile_coords, inventory):
	var map = world.chunk_manager.CHUNKS[chunk_coords].BREAKABLE
	if tile_coords in map.objects:
		var obj = map.objects[tile_coords]
		if obj.ID == Enums.ObjectType.TREE:
			obj.hit_shake()
		pass # hit tree

func alt_use(world, chunk_coords, tile_coords, inventory):
	pass

func set_type():
	type = Enums.ItemType.AXE
