extends MapObject
class_name BreakableObject

@export var HP : int

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
	
	pass

func hit_shake():

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	rotation = 0.0
	
	tween.tween_property(self, "rotation", deg_to_rad(6), 0.05)
	tween.tween_property(self, "rotation", deg_to_rad(-4), 0.05)
	tween.tween_property(self, "rotation", deg_to_rad(2), 0.05)
	tween.tween_property(self, "rotation", 0.0, 0.08)
	
