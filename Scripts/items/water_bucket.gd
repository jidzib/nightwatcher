class_name WaterBucketItem
extends Item

var range: int = 3

#func use(map, position, inventory) -> void:
	#map.CROP.can_water(position, range)
#
#func set_type():
	#type = Enums.ItemType.WATER_BUCKET
