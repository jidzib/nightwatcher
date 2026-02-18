extends Node2D

@export var tile_grid_color := Color(1, 1, 1, 0.25)
@export var chunk_grid_color := Color(1, 1, 0, 1.0)
@export var grid_radius_tiles := 100

func _draw():
	var chunk_manager = get_parent().get_node("ChunkManager")
	
	var size := Util.TILE_SIZE * grid_radius_tiles

	var start := -size
	var end   := size
		
	for x in range(start, end + Util.TILE_SIZE, Util.TILE_SIZE):
		draw_line(
			Vector2(x, start),
			Vector2(x, end),
			tile_grid_color,
			1.0
		)

	# Horizontal lines
	for y in range(start, end + Util.TILE_SIZE, Util.TILE_SIZE):
		draw_line(
			Vector2(start, y),
			Vector2(end, y),
			tile_grid_color,
			1.0
		)
