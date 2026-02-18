class_name HoeItem
extends Item

var range: int = 3

#func use(map, position, inventory):
	#map.TILE_MAP.till_at_world_pos(position, range)
	#map.CROP.can_harvest(position, inventory, range)
#
#func alt_use(map, position, inventory):
	#map.TILE_MAP.until_at_world_pos(position, range)
	#pass
#
#func set_type():
	#type = Enums.ItemType.HOE
