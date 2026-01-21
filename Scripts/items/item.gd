extends Resource
class_name Item

@export var id: int
@export var name: String
var type: int = Enums.ItemType.DEFAULT
@export var max_stack_size: int = 100
@export var texture: Texture2D

func use(world, position, inventory) -> void:
	pass
func alt_use(world, position, inventory) -> void:
	pass
func set_type():
	pass
