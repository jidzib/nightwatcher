extends Node
class_name AStar

var ROWS: int
var COLS: int

var DIRECTIONS : Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(0, 1),
	Vector2i(-1, 0), Vector2i(0, -1)
]
var VALID_TERRAINS : Dictionary[int, bool] = {}

func _init(_ROWS: int, _COLS: int, _VALID_TERRAINS: Dictionary[int, bool]) -> void:
	ROWS = _ROWS
	COLS = _COLS
	VALID_TERRAINS = _VALID_TERRAINS

func is_valid(tile: Vector2i, min_x: int, max_x: int, min_y: int, max_y: int) -> bool:
	var row = tile[0]
	var col = tile[1]
	return tile.x >= min_x and tile.x <= max_x and tile.y >= min_y and tile.y <= max_y

func is_blocked(blocked: Dictionary[Vector2i, int], tile: Vector2i, agent_footprint: Array[Vector2i]):
	for offset in agent_footprint:
		var new_tile : Vector2i = tile+offset
		if new_tile in blocked:
			if blocked[new_tile] not in VALID_TERRAINS:
				return true
	return false

func _is_blocked(blocked: Dictionary[Vector2i, int], tile: Vector2i, agent_footprint: Array[Vector2i]):
	for offset in agent_footprint:
		if tile+offset in blocked:
			
			return true
	return false
	
func search(grid: Dictionary[Vector2i, int], start: Vector2i, goal: Vector2i,
			 agent_footprint: Array[Vector2i]) -> Dictionary:
	
	var min_x : int = start.x - ROWS/2
	var max_x : int = start.x + ROWS/2
	var min_y : int = start.y - ROWS/2
	var max_y : int = start.y + ROWS/2

	var closed_list : Dictionary[Vector2i, bool] = {}
	var cell_details : Dictionary[Vector2i, AStarNode] = {}
	var open_list : MinHeap = MinHeap.new()
	var start_node : AStarNode = AStarNode.new(start, 0, manhattan_distance(start, goal), start)
	
	var best_node : AStarNode = start_node
	# Start node should be centered at ROWS/2, COLS/2
	# So fake -> real is FAKE + START - (ROWS/2, COLS/2)
	cell_details.set(start, start_node)
	open_list.push(start_node)
	
	var found_goal : bool = false
	while open_list.heap.size() > 0:
		var p : AStarNode = open_list.pop()
		if p.pos in closed_list:
			continue
			
		if p.h < best_node.h:
			best_node = p
		if p.pos == goal:
			found_goal = true
			return {"cell_details" : cell_details,
					"goal" : goal}
			
		var i = p.pos[0]
		var j = p.pos[1]
		closed_list.set(p.pos, true)
		
		for dir in DIRECTIONS:
			var neighbor_pos : Vector2i = p.pos + dir
			if neighbor_pos in closed_list:
				continue
			if (not is_valid(neighbor_pos, min_x, max_x, min_y, max_y) or 
							is_blocked(grid, neighbor_pos, agent_footprint)):
				continue
			var neighbor : AStarNode = AStarNode.new(neighbor_pos, 
												p.g+1, 
												manhattan_distance(neighbor_pos, goal),
												p.pos)
			if neighbor_pos not in cell_details or cell_details[neighbor_pos].f > neighbor.f:
				cell_details.set(neighbor_pos, neighbor)
				open_list.push(neighbor)
	#if not found_goal:
		#print("~~~~~~~~~~~~~~~~~~~")
		#print("Failed to find goal")
		#print("START: ", start)
		#print("GOAL: ", goal)
		#print("~~~~~~~~~~~~~~~~~~~")
		##cell_details.clear()
	#
	open_list.clear()
	return {"cell_details" : cell_details,
					"goal" : best_node.pos}
	
func find_nearest(grid: Dictionary[Vector2i, int], start: Vector2i,
				 goal: Vector2i, agent_footprint: Array[Vector2i], 
				 search_range: int = 2056) -> Dictionary:
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
			return {"cell_details" : cell_details, "goal" : cell}
		for dir in DIRECTIONS:
			q.append(cell+dir)
	print("Failed to find goal within ", search_range, " search layers")
	return {"cell_details" : cell_details, "goal" : goal}
	
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
	#path.append(pos)
	path.reverse()
	return path
