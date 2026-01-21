extends Node2D

@onready var map_container = $MapContainer

@onready var grass_layer: TileMapLayer = $MapContainer.GRASS
@onready var farm_layer: TileMapLayer = $Tiles/FarmLayer
@onready var interact_layer: TileMapLayer = $Tiles/InteractLayer
@onready var crop_map: Node2D = $MapContainer.CROP

const FARM_TERRAIN_SET:= 0
const FARM_TERRAIN_ID:= 0

var player_tile_range: int = 3
var mouse_tile: Vector2i

var prev_selected

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		var tile = farm_layer.local_to_map(get_global_mouse_position())
		
func update(new_selected):
	if prev_selected != new_selected:
		if prev_selected:
			prev_selected.deselect()
		if new_selected:
			new_selected.select()
			add_child(new_selected)
		prev_selected = new_selected
	
func check_selected_tile(player_pos: Vector2, item: Item):
	if not item:
		update(null)
		return
	var tile := farm_layer.local_to_map(get_global_mouse_position())
	var selected_tile = get_selectable_at(tile)
	
	if not selected_tile:
		selected_tile = null
	elif not selected_tile.can_interact_with(item):
		selected_tile = null
	elif tile.distance_to(farm_layer.local_to_map(player_pos)) > player_tile_range:
		selected_tile = null
	update(selected_tile)
	
func get_selectable_at(tile: Vector2i):
	if crop_map.objects.has(tile):
		return crop_map.objects[tile]
	if farm_layer.get_cell_source_id(tile) != -1:
		var ref = FarmTile.new()
		ref.tile_coords = tile
		ref.position.x = tile.x*16+8
		ref.position.y = tile.y*16+8
		return ref
	if grass_layer.get_cell_source_id(tile) != -1:
		var ref = GrassTile.new()
		ref.tile_coords = tile
		ref.position.x = tile.x*16+8
		ref.position.y = tile.y*16+8
		return ref
	return null
	
func till_at_world_pos(player_pos: Vector2):
	var cell:= grass_layer.local_to_map(get_global_mouse_position())
	
	if (grass_layer.get_cell_tile_data(cell) == null or
	farm_layer.get_cell_tile_data(cell) != null or
	tile_distance(cell, pos_to_tile(player_pos)) > player_tile_range or
	not map_container.lookup(cell).is_empty()
	):
		return 
	
	var cells: Array[Vector2i] = []
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			if farm_layer.get_cell_tile_data(cell + Vector2i(x, y)) != null:	
				cells.append(cell + Vector2i(x, y))
	
	farm_layer.set_cells_terrain_connect(
		[cell],
		FARM_TERRAIN_SET,
		FARM_TERRAIN_ID
	)
	update_surrounding(cell)
	
func until_at_world_pos(player_pos: Vector2):
	var tile := farm_layer.local_to_map(get_global_mouse_position())
	if crop_map.objects.has(tile) or tile_distance(tile, pos_to_tile(player_pos)) > player_tile_range:
		return
	farm_layer.set_cells_terrain_connect(
		[tile],
		FARM_TERRAIN_SET,
		-1
	)
	update_surrounding(tile)

func update_surrounding(cell: Vector2i):
	var cells: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if farm_layer.get_cell_tile_data(cell + Vector2i(x, y)) != null:	
				cells.append(cell + Vector2i(x, y))
	farm_layer.set_cells_terrain_connect(
		cells,
		FARM_TERRAIN_SET,
		FARM_TERRAIN_ID
	)

func can_plant(player_pos: Vector2, item: Item) -> bool:
	var cell = farm_layer.local_to_map(get_global_mouse_position())
	if (not crop_map.objects.has(cell) and
	farm_layer.get_cell_tile_data(cell) and
	tile_distance(cell, pos_to_tile(player_pos)) <= player_tile_range
	):
		crop_map.plant(cell, item)
		return true
	return false

func can_water(player_pos: Vector2) -> bool:
	var tile = farm_layer.local_to_map(get_global_mouse_position())
	if (crop_map.objects.has(tile) and 
		tile_distance(tile, pos_to_tile(player_pos)) <= player_tile_range
		):
		var curr_crop = crop_map.objects[tile]
		if not curr_crop.watered and curr_crop.stage < curr_crop.crop_resource.max_stage - 1:
			crop_map.water(tile)
			return true
	return false
	
func can_harvest(player_pos: Vector2, inventory: Inventory) -> bool:
	var tile = farm_layer.local_to_map(get_global_mouse_position())
	if (crop_map.objects.has(tile) and 
		crop_map.objects[tile].crop_resource.max_stage-1 == crop_map.objects[tile].stage and 
		tile_distance(tile, pos_to_tile(player_pos)) <= player_tile_range
	):
		crop_map.harvest(tile, inventory)
		return true
	return false

func interact(player_pos: Vector2):
	var tile := interact_layer.local_to_map(get_global_mouse_position())
	if interact_layer.get_cell_tile_data(tile) and tile_distance(tile, pos_to_tile(player_pos)) <= player_tile_range:
		GlobalSignal.day += 1
		GlobalSignal.next_day.emit()

func new_day():
	for tile in crop_map.objects:
		crop_map.grow(tile)
		
func pos_to_tile(world_pos: Vector2) -> Vector2i:
	return farm_layer.local_to_map(world_pos)

func tile_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)

func _on_tree_entered() -> void:
	GlobalSignal.next_day.connect(new_day)

func _on_tree_exited() -> void:
	GlobalSignal.next_day.disconnect(new_day)
