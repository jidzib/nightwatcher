extends Item
class_name AxeItem

func use(world, position, inventory):
	pass # hit tree

func alt_use(world, position, inventory):
	pass

func set_type():
	type = Enums.ItemType.AXE
