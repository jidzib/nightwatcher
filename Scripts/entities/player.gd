extends CharacterBody2D
class_name Player

var movement: Vector2 = Vector2(0, 0)
var acceleration: float = 50
@export var speed: int = 80
var dir: int = 1
var coins: int = 0
var tile_range: int = 3

@onready var inventory: Inventory = $Inventory
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var inventory_slots: Array[int] = [49, 50, 51, 52, 53, 54]

var world: World

func player():
	pass
	
func _ready():
	animated_sprite.play("idle")
	world = get_parent()
	
	GlobalSignal.update_player_coins.emit(500)
	inventory.add_item(load("res://resources/items/hoe.tres"), 1)
	inventory.add_item(load("res://resources/items/axe.tres"), 1)
	inventory.add_item(load("res://resources/items/water_bucket.tres"), 1)
	inventory.add_item(load("res://resources/items/pickaxe.tres"), 1)
	#inventory.add_item(load("res://resources/items/sunflower_seeds.tres"), 10)
	
func _physics_process(delta: float) -> void:
	
	movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if dir == 1 and movement.x < 0:
		dir *= -1
		animated_sprite.flip_h = true
	elif dir == -1 and movement.x > 0:
		dir *= -1
		animated_sprite.flip_h = false
	
	if movement == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
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
			inventory.selected_slot.item.use(world,
											Util.get_chunk_from_world(get_global_mouse_position()),
											Util.get_local_tile_from_world(get_global_mouse_position()),
											inventory)				
	elif Input.is_action_just_pressed("right_click"):
		if inventory.selected_slot.item:
			inventory.selected_slot.item.alt_use(world,
											Util.get_chunk_from_world(get_global_mouse_position()),
											Util.get_local_tile_from_world(get_global_mouse_position()),
											inventory)
	elif Input.is_action_just_pressed("dash"):
		roll()	
		speed = 160
		await get_tree().create_timer(0.5).timeout
		speed = 80
func roll():
	var sign := signf(movement.x)
	var duration = 0.5
	animated_sprite.rotation = 0.0
	var tween := create_tween()
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		animated_sprite,
		"rotation",
		sign * TAU,
		duration
	)
						
func _process(delta: float) -> void:
	var tile = world.chunk_manager.interaction_manager.get_selected_tile()

func save_player():
	var player_data := PlayerData.new()
	player_data.position = position
	player_data.inventory = inventory.get_inventory_as_data()
	ResourceSaver.save(player_data, world.DIR+"player_data.tres")
	
func load_player():
	if not ResourceLoader.exists(world.DIR+"player_data.tres"):
		save_player()
	var player_data = ResourceLoader.load(world.DIR+"player_data.tres")
	position = player_data.position
	inventory.load_inventory(player_data.inventory)
	
func update_coins(amount: int):
	coins += amount

#func load_data(pos: Vector2, inv: Dictionary[Item, int]):
	#global_position = pos
	#inventory.load_inventory(inv)
	
func _on_tree_entered() -> void:
	GlobalSignal.update_player_coins.connect(update_coins)

func _on_tree_exited() -> void:
	GlobalSignal.update_player_coins.disconnect(update_coins)

	
