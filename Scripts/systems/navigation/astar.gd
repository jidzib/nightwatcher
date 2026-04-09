extends Node
class_name AStar

var ROWS: int
var COLS: int


var DIRECTIONS : Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(0, 1),
	Vector2i(-1, 0), Vector2i(0, -1)
]

func _init(_ROWS: int, _COLS: int) -> void:
	ROWS = _ROWS
	COLS = _COLS

func is_valid(tile: Vector2i, center: Vector2i):
	var row = tile[0]
	var col = tile[1]
	return (row >= -ROWS/2 + center[0] and row < ROWS/2 + center[0]
			 and col >= -COLS/2 + center[1] and col < COLS/2 + center[1])

func is_blocked(blocked: Dictionary[Vector2i, MapObject], tile: Vector2i, agent_footprint: Array[Vector2i]):
	for offset in agent_footprint:
		if tile+offset in blocked:
			return true
	return false

#func cell_to_real(cell_coords: Vector2i, start_offset: Vector2i) -> Vector2i:
	#var real_coords : Vector2i = cell_coords + start_offset - Vector2i(ROWS/2, COLS/2)
	#return real_coords
#
#func real_to_cell(real_coords: Vector2i, start_offset: Vector2i) -> Vector2i:
	#var cell_coords: Vector2i = real_coords - start_offset + Vector2i(ROWS/2, COLS/2)
	#return cell_coords

func search(grid: Dictionary[Vector2i, MapObject], start: Vector2i, goal: Vector2i, agent_footprint: Array[Vector2i]):
	var closed_list : Dictionary[Vector2i, bool] = {}
	var cell_details : Dictionary[Vector2i, AStarNode] = {}
	var open_list : MinHeap = MinHeap.new()
	var start_node : AStarNode = AStarNode.new(start, 0, 0, start)
	# Start node should be centered at ROWS/2, COLS/2
	# So fake -> real is FAKE + START - (ROWS/2, COLS/2)
	cell_details.set(start, start_node)
	open_list.push(start_node)
	
	var found_goal : bool = false
	while open_list.heap.size() > 0:
		var p : AStarNode = open_list.pop()
		if p.pos == goal:
			found_goal = true
			return cell_details
		var i = p.pos[0]
		var j = p.pos[1]
		closed_list.set(p.pos, true)
		
		for dir in DIRECTIONS:
			var neighbor_pos : Vector2i = p.pos + dir
			if not is_valid(neighbor_pos, start) or is_blocked(grid, neighbor_pos, agent_footprint):
				continue
			var neighbor : AStarNode = AStarNode.new(neighbor_pos, 
												p.g+1, 
												manhattan_distance(neighbor_pos, goal),
												p.pos)
			if neighbor_pos not in cell_details or cell_details[neighbor_pos].f > neighbor.f:
				cell_details.set(neighbor_pos, neighbor)
				open_list.push(neighbor)
	
	if not found_goal:
		print("~~~~~~~~~~~~~~~~~~~")
		print("Failed to find goal")
		print("START: ", start)
		print("GOAL: ", goal)
		print("~~~~~~~~~~~~~~~~~~~")
		cell_details.clear()
	return cell_details
	
func find_nearest(grid: Dictionary[Vector2i, MapObject], start: Vector2i, goal: Vector2i, agent_footprint: Array[Vector2i], search_range: int = 2056):
	var visited : Dictionary[Vector2i, bool] = {}
	var q : Array[Vector2i] = [goal]
	var cell_details : Dictionary[Vector2i, AStarNode] = {}
	for i in range(search_range):
		print("Search Layer :", i)
		var cell : Vector2i = q.pop_front()
		if cell in visited:
			continue
		visited.set(cell, true)
		cell_details = search(grid, start, cell, agent_footprint)
		if not cell_details.is_empty():
			print("Found goal, returning cell_details")
			return cell_details
		for dir in DIRECTIONS:
			q.append(cell+dir)
	print("Failed to find goal within ", search_range, " search layers")
	return cell_details
	
func manhattan_distance(start: Vector2i, goal: Vector2i) -> int:
	return abs(goal[0]-start[0]) + abs(goal[1]-start[1])

func get_best_path(cell_details: Dictionary[Vector2i, AStarNode], goal: Vector2i) -> Array[Vector2i]:
	if not cell_details:
		return []
	var path : Array[Vector2i] = []
	var pos : Vector2i = Vector2i(goal[0], goal[1])
	
	while not (cell_details[pos].parent_pos[0] == pos[0] and cell_details[pos].parent_pos[1] == pos[1]):
		path.append(pos)
		pos = cell_details[pos].parent_pos
	path.append(pos)
	path.reverse()
	return path
