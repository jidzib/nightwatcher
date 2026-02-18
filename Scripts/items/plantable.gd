class_name Plantable
extends Item

@export var crop_resource: Resource
var range: int = 3

#func alt_use(map, position, inventory) -> void:
	#if map.CROP.can_plant(position, self, range):
		#inventory.remove_item(self, 1)
#
#func set_type():
	#type = Enums.ItemType.PLANTABLE
