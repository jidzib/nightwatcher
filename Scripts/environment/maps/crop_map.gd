extends Map
class_name CropMap

var empty_crop = preload("res://Scenes/CropObject.tscn")

func _ready():
	z_index = 1
	y_sort_enabled = true
	
func plant(tile: Vector2i, item: Item):	
	var new_crop = empty_crop.instantiate()
	new_crop.crop_resource = item.crop_resource
	new_crop.position = Vector2(tile.x * new_crop.TILE_SIZE + new_crop.TILE_SIZE/2, tile.y * new_crop.TILE_SIZE + new_crop.TILE_SIZE/2)
	objects[tile] = new_crop
	add_child(new_crop)
	
func water(tile: Vector2i):
	objects[tile].watered = true
	objects[tile].water_overlay.visible = true
	
func grow(tile: Vector2i):
	if objects[tile].watered:
		objects[tile].watered = false
		objects[tile].water_overlay.visible = false
		next_stage(tile)
		objects[tile].set_sprite()

func harvest(tile: Vector2i, inventory: Inventory):
	inventory.add_item(objects[tile].crop_resource.harvestable, 1)
	objects[tile].queue_free()
	objects.erase(tile)
	
func next_stage(tile: Vector2i):
	if objects[tile].stage < objects[tile].crop_resource.max_stage - 1:
		objects[tile].stage += 1
