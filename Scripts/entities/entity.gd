extends CharacterBody2D
class_name Entity

@export var label : Label
@export var active_area : Area2D


@export var ID : Enums.EntityType

# NODES
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer
@export var hitbox : CollisionShape2D
@export var navigation_component : NavigationComponent
var interaction_manager : InteractionManager

# STATS
@export var speed : float
@export var acceleration : float
@export var health : float
var current_health : float

var tile_coords : Vector2i
var movement : Vector2
@export var tile_footprint : Array[Vector2i] = [Vector2i.ZERO]
#var dir : Vector2i

var active : bool = false
var animation_locked : bool = false

func initialize(_grid: Dictionary[Vector2i, int], _interaction_manager) -> void:
	navigation_component.grid = _grid
	interaction_manager = _interaction_manager
	
func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	animation_player.play("idle")
	
	await get_tree().physics_frame
	
	var bodies : Array[Node2D] = active_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("player"):
			active = true

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("enter"):
		#var mouse_pos : Vector2 = get_global_mouse_position()
		#mouse_pos = Util.get_tile_from_world(mouse_pos)
		#navigation_component.find_path(mouse_pos)
		#pass
		
func _physics_process(delta: float) -> void:
	if not active:
		stop_moving()
		return
	tile_coords = Vector2i(floor(position.x / float(Util.TILE_SIZE)),
					floor(position.y / float(Util.TILE_SIZE)))
	#tile_coords = Vector2i(
					#floor((position.x + Util.TILE_SIZE/2) / Util.TILE_SIZE),
					#floor((position.y + Util.TILE_SIZE/2) / Util.TILE_SIZE)
	#)
	#label.text = str(tile_coords.x, ", ", tile_coords.y)
	navigation_component.update_path()
	#print(navigation_component.goal)
	velocity = lerp(velocity, speed*movement, delta*acceleration)
	if velocity.is_zero_approx():
		velocity = Vector2.ZERO
	
	if not animation_locked:
		if velocity == Vector2.ZERO:
			animation_player.play("idle")
		else:
			animation_player.play("walk")
			
	move_and_slide()


func stop_moving():
	velocity = Vector2.ZERO
	movement = Vector2.ZERO
	#navigation_component.path = []
	#animation_player.play("idle")
	
func encode(data: PackedByteArray) -> void:
	var chunk_coords : Vector2i = Util.get_chunk_from_tile(tile_coords)
	var local_coords : Vector2i = tile_coords - chunk_coords * Util.CHUNK_SIZE
	data.append(ID)
	data.append(local_coords.x)
	data.append(local_coords.y)
	
func decode(data: PackedByteArray, i: int) -> void:
	tile_coords = Vector2i(data[i+1], data[i+2])

func get_data_size() -> int:
	return 3

func update_activity() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Entity activated")
		active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("Entity deactivated")
		active = false
