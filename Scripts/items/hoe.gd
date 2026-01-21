class_name HoeItem
extends Item

func use(world, position, inventory):
	world.till_at_world_pos(position)
	world.can_harvest(position, inventory)

func alt_use(world, position, inventory):
	world.until_at_world_pos(position)

func set_type():
	type = Enums.ItemType.HOE
