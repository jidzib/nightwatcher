extends Tile
class_name GrassTile

func can_interact_with(item: Item) -> bool:
	if item is HoeItem:
		return true
	return false
