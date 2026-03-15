extends CanvasLayer
class_name Inventory

var inventory: Array[ItemSlot] = []

var empty_slot = preload("res://Scenes/ui/ItemSlot.tscn")
@onready var grid_container: GridContainer = $GridContainer
@onready var background : TextureRect = $Background
var hotbar_size : int = 6
@export var max_slots: int = 24
var selected_slot: ItemSlot = null

var showing : bool = true

func _ready():
	for i in range(max_slots):
		var new_slot = empty_slot.instantiate()
		grid_container.add_child(new_slot)
		inventory.append(new_slot)
	selected_slot = inventory[-1]
	update_display()
	switch_visible()
	
func add_item(item: Item, amount: int) -> void:
		
	for i in range(max_slots):
		if inventory[i].item and inventory[i].item.name == item.name:
			inventory[i].item = item
			inventory[i].quantity += amount
			update_display()
			return
		elif grid_container.get_child(i).quantity == 0:
			inventory[i].item = item
			inventory[i].quantity += amount
			update_display()
			return

func remove_item(item: Item, amount: int) -> bool:
	for i in range(max_slots):
		if inventory[i].item == item:
			var remove_count = min(inventory[i].quantity, amount)
			inventory[i].quantity -= remove_count
			amount -= remove_count
			if inventory[i].quantity == 0:
				inventory[i].item = null
			if amount == 0:
				update_display()
				return true
	update_display()
	return false

func has_item(item: Item) -> bool:
	for i in range(max_slots):
		if inventory[i].item == item:
			return true
	return false

func get_item_index(item: Item) -> int:
	for i in range(max_slots):
		if inventory[i].item == item:
			return i
	return -1
	
func update_display():
	for child in grid_container.get_children():
		child.update()

func load_to_slot(item: Item, amount: int, slot: int):
	inventory[slot].item = item
	inventory[slot].quantity = amount

func get_inventory_as_data() -> InventoryData:
	var inventory_data := InventoryData.new()
	for i in range(len(inventory)):
		if inventory[i].item:
			inventory_data.items.append(inventory[i].item.id)
			inventory_data.counts.append(inventory[i].quantity)
			inventory_data.slots.append(i)
	return inventory_data

func reset():
	inventory = []
	for child in grid_container.get_children():
		child.free()

func load_inventory(inventory_data: InventoryData):
	for i in range(len(inventory_data.items)):
		var slot = inventory_data.slots[i]
		inventory[slot].item = References.ITEMS[inventory_data.items[i]]
		inventory[slot].quantity = inventory_data.counts[i]
	update_display()	

func switch_visible():
	
	if showing:
		for i in range(hotbar_size, max_slots):
			inventory[i].visible = false
		background.visible = false
		showing = false
	
	else:
		for i in range(hotbar_size, max_slots):
			inventory[i].visible = true
		background.visible = true
		showing = true
		
func _on_tree_entered() -> void:
	#GlobalSignal.next_day.connect(update_day_display)
	pass
func _on_tree_exited() -> void:
	#GlobalSignal.next_day.disconnect(update_day_display)
	pass
