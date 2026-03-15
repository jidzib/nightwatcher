extends Control
class_name ItemSlot

var item: Item
var quantity: int = 0
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var selected: Sprite2D = $Selected

func _ready():
	update()
		 
func update():
	if item:
		sprite.texture = item.texture
		sprite.scale = Vector2(2.0, 2.0)
	else:
		sprite.texture = null
	label.text = str(quantity)
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is ItemSlot

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp_item = item
	var temp_quantity = quantity
	
	item = data.item
	quantity = data.quantity
	
	data.item = temp_item
	data.quantity = temp_quantity
	data.update()
	
	update()

func _get_drag_data(at_position: Vector2) -> Variant:
	return self
	
