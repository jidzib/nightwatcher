extends Tile
class_name FarmTile

func can_interact_with(item: Item) -> bool:
	if item is HoeItem or item is Plantable:
		return true
	return false
