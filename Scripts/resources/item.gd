extends Resource
class_name Item

@export var id: int
@export var name: String
var type: int = Enums.ItemType.DEFAULT
@export var max_stack_size: int = 100
@export var texture: Texture2D

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, inventory: Inventory) -> void:
	pass
func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, inventory: Inventory) -> void:
	pass
func set_type():
	pass
