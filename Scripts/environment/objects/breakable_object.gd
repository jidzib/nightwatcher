extends MapObject
class_name BreakableObject

@export var HP : int
@export var item_drop: Item
@export var drop_count: int

func pack() -> BreakableResource:
	var resource = BreakableResource.new()
	resource.ID = ID
	resource.tile_coords = position / Util.TILE_SIZE
	resource.CATEGORY = CATEGORY
	resource.HP = HP
	return resource

func hit(damage: int):
	# TAKE AWAY HP
	HP -= damage
	# SHAKE
	hit_shake()
	# IF HP <= 0: DROP RESOURCES AND REMOVE OBJECT (FROM OBJECTS DICT IN MAP AND FROM SCENE TREE)
	if HP <= 0:
		for i in range(drop_count):
			drop_item()
			
		remove()

func drop_item():
		var packed_dropped_item = load("res://Scenes/systems/DroppedItem.tscn")
		var dropped_item = packed_dropped_item.instantiate()
		dropped_item.item = item_drop
		dropped_item.position = position
		get_parent().add_child(dropped_item)
	
func hit_shake():

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	rotation = 0.0
	
	tween.tween_property(self, "rotation", deg_to_rad(6), 0.05)
	tween.tween_property(self, "rotation", deg_to_rad(-4), 0.05)
	tween.tween_property(self, "rotation", deg_to_rad(2), 0.05)
	tween.tween_property(self, "rotation", 0.0, 0.08)
	
