class_name MinHeap

var heap : Array[AStarNode] = []

func push(item: AStarNode):
	heap.append(item)
	bubble_up(len(heap)-1)

func pop() -> AStarNode:
	if not heap:
		return null

	swap(0, len(heap)-1)
	var item : AStarNode = heap.pop_back()
	bubble_down(0)
	return item
	
func bubble_up(index: int):
	var parent: int = floor((index-1) / 2) 
	while index > 0 and heap[index].f < heap[parent].f:
		swap(index, parent)
		index = parent
		parent = floor((index-1) / 2)
		
func bubble_down(index: int):
	var size = len(heap)
	while true:
		var l : int = 2*index+1
		var r : int = 2*index+2
		var smallest = index
		
		if l < size and heap[l].f < heap[smallest].f:
			smallest = l
		if r < size and heap[r].f < heap[smallest].f:
			smallest = r
			
		if smallest == index:
			break
		
		swap(index, smallest)
		index = smallest

func swap(i: int, j: int):
	var temp: AStarNode = heap[i]
	heap[i] = heap[j]
	heap[j] = temp

func clear():
	for node in heap:
		node.queue_free()
	heap = []
