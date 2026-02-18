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
	
