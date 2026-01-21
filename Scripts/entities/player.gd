extends CharacterBody2D

var movement: Vector2 = Vector2(0, 0)
var acceleration: float = 50
var speed: int = 75
var dir: int = 1
var coins: int = 0
var tile_range: int = 3

@onready var inventory: Inventory = $Inventory
@onready var sprite: Sprite2D = $Sprite2D

var inventory_slots: Array[int] = [49, 50, 51, 52, 53, 54]

var current_map: MapContainer

func player():
	pass
	
func _ready():
	GlobalSignal.update_player_coins.emit(500)
	
	inventory.add_item(load("res://resources/items/hoe.tres"), 1)
	inventory.add_item(load("res://resources/items/axe.tres"), 1)
	inventory.add_item(load("res://resources/items/water_bucket.tres"), 1)
	inventory.add_item(load("res://resources/items/sunflower_seeds.tres"), 10)
	
func _physics_process(delta: float) -> void:
	
	movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if dir == 1 and movement.x < 0:
		dir *= -1
		sprite.flip_h = true
	elif dir == -1 and movement.x > 0:
		dir *= -1
		sprite.flip_h = false
	velocity = lerp(velocity, speed*movement.normalized(), delta*acceleration)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode in inventory_slots:
		if inventory.inventory[int(event.as_text()) - 1]:
			inventory.selected_slot.selected.visible = false
			inventory.selected_slot = inventory.inventory[int(event.as_text()) - 1]
			inventory.selected_slot.selected.visible = true

	if Input.is_action_just_pressed("inventory"):
		inventory.visible = !inventory.visible
	elif Input.is_action_just_pressed("left_click"):
		if inventory.selected_slot.item:
			inventory.selected_slot.item.use(get_parent(), global_position, inventory)				
	elif Input.is_action_just_pressed("right_click"):
		if inventory.selected_slot.item:
			inventory.selected_slot.item.alt_use(get_parent(), global_position, inventory)
	elif Input.is_action_just_pressed("interact"):
		get_parent().interact(global_position)

func _process(delta: float) -> void:
	get_parent().check_selected_tile(global_position, inventory.selected_slot.item)
	
func update_coins(amount: int):
	coins += amount
	
func _on_tree_entered() -> void:
	GlobalSignal.update_player_coins.connect(update_coins)
func _on_tree_exited() -> void:
	GlobalSignal.update_player_coins.disconnect(update_coins)
