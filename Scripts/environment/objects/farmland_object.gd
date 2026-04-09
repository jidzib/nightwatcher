extends MapObject
class_name FarmlandObject

var bitmask : int = 0
var watered : bool = false
var stage : int = 0
var crop_id : int = 0

var crop : GrowableObject = null

@onready var dehydrated = $Dehydrated

@onready var autotile : Autotile = $Autotile
var chunk_coords : Vector2i

func initialize():
	super.initialize()
	is_collider = false
	chunk_coords = Util.get_chunk_from_world(global_position)
	autotile.switch_tile(bitmask)
	#autotile.switch_tile(15)
	if crop:
		set_watered(watered)

func plant(new_crop: GrowableObject):
	crop = new_crop
	crop_id = crop.ID
	add_child(crop)
	set_watered(false)
	
func water():
	set_watered(true)

func harvest():
	for i in range(crop.drop_count):
		crop.drop_item()
	crop.queue_free()
	crop = null
	crop_id = 0
	stage = 0
	
func can_plant() -> bool:
	if crop_id:
		return false
	return true

func can_water() -> bool:
	if !crop_id or is_max_stage() or watered:
		return false
	return true

func set_watered(wtrd: bool):
	watered = wtrd
	dehydrated.visible = !watered

func is_max_stage() -> bool:
	return crop.current_stage == crop.MAX_STAGE


func set_highlighted(value: bool):
	if !crop:
		super.set_highlighted(value)
	else:
		crop.set_highlighted(value)
	
func encode(data: PackedByteArray) -> void:
	super.encode(data)
	data.append(bitmask)
	data.append(watered)
	data.append(stage)
	data.append(crop_id)
	
func decode(data: PackedByteArray, i: int) -> void:
	super.decode(data, i)
	print("Decoding farmland object")
	print("Data entry point: ", i)
	print("Tile Coords: ", tile_coords)
	bitmask = data[i+3]
	watered = bool(data[i+4])
	stage = data[i+5]
	crop_id = data[i+6]
	
func get_data_size() -> int:
	return 7
	
func spawn_runtime_dependencies(refs):
	
	if crop_id:
		crop = refs.OBJECTS[crop_id].instantiate()
		add_child(crop)
		crop.current_stage = stage

func grow():
	stage += 1
	crop.set_stage(stage)
	if !is_max_stage():
		set_watered(false)
	
func _process(delta: float) -> void:
	if crop and watered and !is_max_stage():
		if randi_range(0, 200) == 200:
			grow()
			
