extends MapObject
class_name BreakableObject

var health: float
var drop_amount: int


func set_type():
	obj_type = Enums.ObjectType.BREAKABLE

func destroy():
	pass
func drop_item():
	pass
