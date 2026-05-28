extends Item
class_name Spawnable

@export var entity : String
@export var can_place_on : Array[String] = []

func use(world: World, tile_coords: Vector2i, player: Player) -> void:
	var chunk_coords : Vector2i = Util.get_chunk_from_tile(tile_coords)
	var local_coords : Vector2i = Util.get_local_from_global_tile(tile_coords)
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	var _entity = References.ENTITIES[Enums.EntityType[entity]].instantiate()
	if chunk.add_entity(_entity, local_coords):
		player.inventory.remove_item(self, 1)
	else:
		_entity.queue_free()
	
func alt_use(world: World, tile_coords: Vector2i, player: Player) -> void:
	pass
