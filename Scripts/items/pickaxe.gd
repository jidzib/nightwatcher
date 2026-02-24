extends Item
class_name PickaxeItem

func use(world, chunk_coords, tile_coords, inventory):
	var map = world.chunk_manager.CHUNKS[chunk_coords].BREAKABLE
	if tile_coords in map.objects:
		var obj = map.objects[tile_coords]
		if obj.ID == Enums.ObjectType.ROCK:
			obj.hit(1)
		pass # hit tree

func alt_use(world, chunk_coords, tile_coords, inventory):
	pass

func set_type():
	type = Enums.ItemType.PICKAXE
