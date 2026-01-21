extends CanvasLayer

@export var item_list: Dictionary[int, Item] = {}

@export var sellPrices: Dictionary[int, int] # Item ID : Price

@onready var scroll = $ScrollContainer/VBoxContainer
@onready var display = $ScrollContainer
@onready var close_button = $Button

var selected_item_id: int

var sample = preload("res://Scenes/ui/sample_shop_item.tscn").instantiate()

func _ready():
	for id in item_list:
		scroll.custom_minimum_size.y += 52.0
		var new_item = sample.duplicate()
		new_item.get_node("ItemIcon").texture = item_list[id].texture
		new_item.get_node("ItemName").text = item_list[id].name
		new_item.get_node("ItemPrice").text = str(sellPrices[id])
		new_item.item_id = id
		scroll.add_child(new_item)

func close_window():
	visible = false
	selected_item_id = 0
	
func _on_button_pressed() -> void:
	close_window()

func _on_buy_button_pressed() -> void:
	if selected_item_id:
		var player = get_parent().player_ref
		if player.coins - sellPrices[selected_item_id] >= 0:
			player.inventory.add_item(item_list[selected_item_id], 1)
			GlobalSignal.update_player_coins.emit(-sellPrices[selected_item_id])
			
	
func set_selected_item_id(item_id: int):
	selected_item_id = item_id
	
func _on_tree_entered() -> void:
	GlobalSignal.shop_item_selected.connect(set_selected_item_id)
func _on_tree_exited() -> void:
	GlobalSignal.shop_item_selected.disconnect(set_selected_item_id)
