class_name WaterBucketItem
extends Item

func use(world, position, inventory) -> void:
	world.can_water(position)

func set_type():
	type = Enums.ItemType.WATER_BUCKET
