extends Control

class_name SampleShopItem


@onready var item_icon: Sprite2D = $ItemIcon
@onready var item_name: RichTextLabel = $ItemName
@onready var item_price: RichTextLabel = $ItemPrice
var item_id: int

func _on_button_pressed() -> void:
	GlobalSignal.shop_item_selected.emit(item_id)
