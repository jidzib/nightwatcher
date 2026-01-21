class_name Plantable
extends Item

@export var crop_resource: Resource

func alt_use(world, position, inventory) -> void:
	if world.can_plant(position, self):
		inventory.remove_item(self, 1)

func set_type():
	type = Enums.ItemType.PLANTABLE
