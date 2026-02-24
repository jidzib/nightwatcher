extends Node2D
class_name InteractionManager

var chunk_manager: ChunkManager
var selected_object = null

func get_selected_tile():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var chunk_coords: Vector2i = Util.get_chunk_from_world(mouse_pos)
	if chunk_coords not in chunk_manager.CHUNKS:
		#print("Invalid chunk coordinates for tile selection")
		return
	var chunk: Chunk = chunk_manager.CHUNKS[chunk_coords]
	var tile_coords: Vector2i = Util.get_local_tile_from_world(mouse_pos)
	
	# First we check objects
	var obj = chunk.get_object_at_tile(tile_coords)
	if obj:
		var select_new = set_selected(obj)
		if select_new:
			return obj
	else:
		if selected_object:
			deselect()
	
	# Then we check tiles

	var tile = chunk.get_tile_at_tile(tile_coords)
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
	
	
