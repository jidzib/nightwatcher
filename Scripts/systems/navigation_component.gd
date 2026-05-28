extends Node
class_name NavigationComponent

@export var parent : Entity

@export var VALID_TERRAINS : Dictionary[int, bool] = {}
## NAVIGATION
#var tile_coords : Vector2i
var astar : AStar = AStar.new(Util.ENTITY_NAVIGATION_RANGE, Util.ENTITY_NAVIGATION_RANGE, VALID_TERRAINS)
var grid : Dictionary[Vector2i, int]
var path : Array[Vector2i] = []
var path_index : int = 0
	
#func find_path(goal_coords: Vector2i):
	#var nearest = astar.search(grid, parent.tile_coords, goal_coords, parent.tile_footprint)
	#var cell_details = nearest["cell_details"]
	#path_index = 0
	#if not cell_details:
		#print("No path available")
		#return
	#path = astar.get_best_path(cell_details, nearest["goal"])
	#for i in range(path.size()):
		#path[i] *= Util.TILE_SIZE

func find_nearest(goal_coords: Vector2i) -> Dictionary: # { "cell_details", "goal" }
	return astar.search(grid, parent.tile_coords, goal_coords, parent.tile_footprint)

func set_path(cell_details: Dictionary[Vector2i, AStarNode], goal_coords: Vector2i):
	path_index = 0
	path = astar.get_best_path(cell_details, goal_coords)
	for i in range(path.size()):
		path[i] *= Util.TILE_SIZE
		path[i] += Vector2i(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	draw_path()
	
func clear_path():
	path_index = 0
	path = []

func update_path() -> void:
	if path.size() > 0:
		if parent.global_position.distance_to(path[path_index]) <= 2.0:
			if path_index == path.size()-1:
				print("completed path")
				path = []
				parent.stop_moving()
				return
			path_index += 1
		update_movement(parent.global_position.direction_to(path[path_index]))
	else:
		parent.stop_moving()

func update_movement(_movement: Vector2) -> void:
	parent.movement = _movement

func draw_path() -> void:
	for i in range(path.size()):
		var point : ColorRect = ColorRect.new()
		point.size = Vector2(4, 4)
		point.color = Color.PURPLE
		point.global_position = path[i]
		add_child(point)
