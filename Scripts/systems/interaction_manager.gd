extends Node2D
class_name InteractionManager

var chunk_manager: ChunkManager
var selected_object = null

func get_selected_tile(player: Player):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var chunk_coords: Vector2i = Util.get_chunk_from_world(mouse_pos)
	if chunk_coords not in chunk_manager.CHUNKS:
		return null
	var chunk: Chunk = chunk_manager.CHUNKS[chunk_coords]
	var tile_coords: Vector2i = Util.get_local_tile_from_world(mouse_pos)

	if Util.get_tile_distance(Util.get_tile_from_world(player.position), player.chunk_coords,
							  tile_coords, chunk_coords) > player.tile_range:
		return null
		
	var tile = chunk.get_tile_at_tile(tile_coords)
	if tile:
		return tile
		
	return null

func get_selected_object(player: Player):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var chunk_coords: Vector2i = Util.get_chunk_from_world(mouse_pos)
	if chunk_coords not in chunk_manager.CHUNKS:
		return null
	var chunk: Chunk = chunk_manager.CHUNKS[chunk_coords]
	var tile_coords: Vector2i = Util.get_local_tile_from_world(mouse_pos)
	
	var distance = Util.get_tile_distance(Util.get_local_tile_from_world(player.position), player.chunk_coords,
							  tile_coords, chunk_coords)
	if distance > player.tile_range:
		return null
	
	var obj = chunk.get_object_at_tile(tile_coords)
	return obj
	
func process_selection(player: Player):
	var obj = get_selected_object(player)
	if obj:
		var select_new = set_selected(obj)
		if select_new:
			return obj
	else:
		if selected_object:
			deselect()
	
	var tile = get_selected_tile(player)
	if tile:
		return tile
	
	return null
	
func set_selected(obj) -> bool:
	if obj == selected_object:
		false
	if selected_object:
		selected_object.set_highlighted(false)
	
	selected_object = obj
	
	selected_object.set_highlighted(true)
	return true
		
func deselect():
	selected_object.set_highlighted(false)
	selected_object = null
	
	
