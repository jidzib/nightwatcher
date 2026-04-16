extends Node2D
class_name InteractionManager

@export var chunk_manager: ChunkManager

var selected_object = null
var selected_tile = null

##func get_tile() -> int:
	##return -1

func get_object(tile_coords: Vector2i) -> MapObject:
	if tile_coords not in chunk_manager.occupied_tiles:
		return null
	return chunk_manager.occupied_tiles[tile_coords]

func get_selected_tile(player: Player):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var chunk_coords: Vector2i = Util.get_chunk_from_world(mouse_pos)
	if chunk_coords not in chunk_manager.CHUNKS:
		return null
	var chunk: Chunk = chunk_manager.CHUNKS[chunk_coords]
	var tile_coords: Vector2i = Util.get_local_tile_from_world(mouse_pos)

	var distance = player.global_position.distance_to(mouse_pos)

	if distance > player.tile_range * Util.TILE_SIZE: 
		selected_tile = -1
		return -1
		
	var tile_id = chunk.get_tile_id(tile_coords)
	if tile_id != -1:
		selected_tile = tile_id
		return tile_id
	selected_tile = -1
	return -1
	
func get_selected_object(player: Player):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var distance : float = player.global_position.distance_to(mouse_pos)
	if distance > player.tile_range * Util.TILE_SIZE:
		return null
	var tile_coords: Vector2i = Util.get_tile_from_world(mouse_pos)
	if tile_coords not in chunk_manager.occupied_tiles:
		return null
	return chunk_manager.occupied_tiles[tile_coords]

func process_selection(player: Player):
	var obj = get_selected_object(player)
	if obj and obj != selected_object:
		if selected_object:
			deselect()
		select(obj)
	elif !obj and selected_object:
		deselect()
	
	var tile = get_selected_tile(player)

func select(obj: MapObject):
	obj.set_highlighted(true)
	selected_object = obj
	
func set_selected(obj):
	if obj == selected_object:
		return false
	if selected_object:
		selected_object.set_highlighted(false)
	
	selected_object = obj
	
	selected_object.set_highlighted(true)
	return true
		
func deselect():
	selected_object.set_highlighted(false)
	selected_object = null
	
	
