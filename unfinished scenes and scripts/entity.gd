extends CharacterBody2D
class_name Entity

# CANVAS
@onready var sprite : AnimatedSprite2D = $Sprite
@onready var coord_display : Label = $UI/CoordinateDisplay
# STATS
@export var speed : float = 60.0
var acceleration : float = 50.0
# NAVIGATION
@export var tile_footprint : Array[Vector2i] = [Vector2i.ZERO]
var tile_coords : Vector2i
var astar : AStar = AStar.new(Util.ENTITY_NAVIGATION_RANGE, Util.ENTITY_NAVIGATION_RANGE)
var grid : Dictionary[Vector2i, MapObject]
var path : Array[Vector2i] = []
var path_index : int = 0
var goal : Vector2i


var player: Player

static var ref : PackedScene = load("res://Scenes/entities/Entity.tscn")
static func new_entity(_grid: Dictionary[Vector2i, MapObject]) -> Entity:
	var entity : Entity = ref.instantiate()
	entity.grid = _grid
	return entity

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	tile_coords = Vector2i(
					floor((position.x + Util.TILE_SIZE/2) / Util.TILE_SIZE),
					floor((position.y + Util.TILE_SIZE/2) / Util.TILE_SIZE)
	)
	coord_display.text = str(tile_coords)
	if path.size() > 0:
		if position.distance_to(path[path_index]) <= 0.5:
			if path_index == path.size()-1:
				path = []
				velocity = Vector2.ZERO
				return
			path_index += 1
		var dir : Vector2 = position.direction_to(path[path_index])
		velocity = dir * speed * delta * acceleration
		move_and_slide()
	
	if velocity.is_zero_approx():
		sprite.play("idle")
	else:
		sprite.play("walk")
		
func find_path(grid: Dictionary[Vector2i, MapObject], goal_coords: Vector2i):
	var cell_details = astar.search(grid, tile_coords, goal_coords, tile_footprint)
	path_index = 0
	if not cell_details:
		print("No path available")
		return
	path = astar.get_best_path(cell_details, goal_coords) # <- goal coords should be cell_details[0] or -1
	for i in range(path.size()):
		path[i] *= Util.TILE_SIZE
		#path[i] += Vector2i(Util.TILE_SIZE/2, Util.TILE_SIZE/2)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter") and player:
		find_path(grid, player.tile_coords)	
		print("NAVIGATION TO PLAYER AT ", player.tile_coords)
		print("PATH FOUND : ", path)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
