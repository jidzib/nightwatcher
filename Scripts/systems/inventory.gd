extends CanvasLayer
class_name Inventory

var inventory: Array[ItemSlot] = []

var empty_slot = preload("res://Scenes/ui/ItemSlot.tscn")
@onready var grid_container: GridContainer = $GridContainer

@export var max_slots: int = 6
var selected_slot: ItemSlot = null

@onready var day_count: Label = $DayCount

func _ready():
	for i in range(max_slots):
		var new_slot = empty_slot.instantiate()
		grid_container.add_child(new_slot)
		inventory.append(new_slot)
	selected_slot = inventory[-1]
	update_display()
	update_day_display()
	
func add_item(item: Item, amount: int) -> void:
	for i in range(max_slots):
		if inventory[i].item and inventory[i].item.name == item.name:
			inventory[i].item = item
			inventory[i].quantity += amount
			update_display()
			print("Added ", amount, inventory[i].item.name)
			return
		elif grid_container.get_child(i).quantity == 0:
			inventory[i].item = item
			inventory[i].quantity += amount
			print("Added ", amount, inventory[i].item.name)
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
	
func update_display():
	for child in grid_container.get_children():
		child.update()

func update_day_display():
	day_count.text = str(GlobalSignal.day)

func reset():
	inventory = []
	for child in grid_container.get_children():
		child.free()
	
func load_inventory(saved_inventory: Dictionary[Item, int]):
	reset()
	_ready()
	for item in saved_inventory:
		#print("Item: ", item.name)
		#print("Quantity: ", saved_inventory[item])
		#print("~~~~~~~~~~~~~~~")
		add_item(item, saved_inventory[item])

func save_inventory() -> Dictionary[Item, int]:
	var items : Dictionary[Item, int]
	for item_slot in inventory:
		if item_slot.item:
			#print("Item: ", item_slot.item.name)
			#print("Quantity: ", item_slot.quantity)
			#print("~~~~~~~~~~~~~~~")
			items.set(item_slot.item, item_slot.quantity)
	return items
	
func _on_tree_entered() -> void:
	GlobalSignal.next_day.connect(update_day_display)
func _on_tree_exited() -> void:
	GlobalSignal.next_day.disconnect(update_day_display)
