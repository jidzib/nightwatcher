extends CharacterBody2D
class_name Player

var movement: Vector2 = Vector2(0, 0)
var acceleration: float = 50
@export var speed: int = 80
var dir: int = 1
var tile_range: int = 3

@onready var inventory: Inventory = $UI/Inventory

@onready var camera : Camera2D = $Camera2D

var inventory_slots: Array[int] = [49, 50, 51, 52, 53, 54]

var world: World

enum MovementStates {
	IDLE, WALK
}

enum ActionStates {
	NO_ACTION, USING_ITEM
}

var movement_state: MovementStates = MovementStates.IDLE
var action_state: ActionStates = ActionStates.NO_ACTION

@onready var movement_state_machine: StateMachine = $MovementStateMachine
@onready var action_state_machine: StateMachine = $ActionStateMachine
@onready var console = $UI/Console

@onready var sprite : Node2D = $Sprites
@onready var animation_tree : AnimationTree = $AnimationTree

var chunk_coords: Vector2i

var interaction_manager = InteractionManager.new()

func player():
	pass
	
func _ready():
	world = get_parent()
	console.player = self
	movement_state_machine.init(self)
	action_state_machine.init(self)
	add_child(interaction_manager)
	
func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	
	movement.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if dir == 1 and movement.x < 0:
		dir *= -1
		sprite.scale.x = -1.0
	elif dir == -1 and movement.x > 0:
		dir *= -1
		sprite.scale.x = 1.0
	
	velocity = lerp(velocity, speed*movement.normalized(), delta*acceleration)
	if velocity.is_zero_approx():
		velocity = Vector2.ZERO
	move_and_slide()

func _input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	if event is InputEventKey and event.keycode in inventory_slots:
		if inventory.inventory[int(event.as_text()) - 1]:
			inventory.selected_slot.selected.visible = false
			inventory.selected_slot = inventory.inventory[int(event.as_text()) - 1]
			inventory.selected_slot.selected.visible = true

	if Input.is_action_just_pressed("inventory"):
		inventory.switch_visible()
		
	elif Input.is_action_just_pressed("left_click"):
		if inventory.selected_slot.item:
			inventory.selected_slot.item.use(world,
											Util.get_chunk_from_world(get_global_mouse_position()),
											Util.get_local_tile_from_world(get_global_mouse_position()),
											self)				
	elif Input.is_action_just_pressed("right_click"):
		if inventory.selected_slot.item:
			inventory.selected_slot.item.alt_use(world,
											Util.get_chunk_from_world(get_global_mouse_position()),
											Util.get_local_tile_from_world(get_global_mouse_position()),
											self)
	elif Input.is_action_just_pressed("open_console"):
		open_console()	
	
func _process(delta: float) -> void:
	
	var tile = interaction_manager.process_selection(self)
	movement_state_machine.process_frame(delta)
	
	if inventory.selected_slot and inventory.selected_slot.item:
		$Sprites/Item.texture = inventory.selected_slot.item.texture
	else:
		$Sprites/Item.texture = null

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
	
func open_console():
	console.visible = !console.visible
	set_physics_process(!is_physics_processing())
