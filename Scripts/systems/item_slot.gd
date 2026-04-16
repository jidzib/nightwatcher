extends Control
class_name ItemSlot

var item: Item
var quantity: int = 0
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var selected: Sprite2D = $Selected

@onready var tier_color : ColorRect = $ColorRect

func _ready():
	update()
		 
func update():
	if item:
		sprite.texture = item.texture
		sprite.scale = Vector2(2.0, 2.0)
		
		match item.tier:
			Enums.Tier.COMMON:
				tier_color.color = Color.DIM_GRAY
			Enums.Tier.UNCOMMON:
				tier_color.color = Color.LIME_GREEN
			Enums.Tier.RARE:
				tier_color.color = Color.BLUE
			Enums.Tier.LEGENDARY:
				tier_color.color = Color.GOLD
			Enums.Tier.OTHERWORLDY:
				tier_color.color = Color.REBECCA_PURPLE
		tier_color.color.a = 0.3
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
	
