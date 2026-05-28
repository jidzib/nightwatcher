extends Entity
class_name Creature

# STATS
@export var hunger : Need
@export var energy : Need

# STATE MACHINE
@export var action_state_machine : StateMachine
enum ActionStates {
	IDLE,
	WANDER,
	EATING,
	SLEEPING,
	SEARCHING_FOOD,
	SEARCHING_BED
}

var action_state : ActionStates = ActionStates.IDLE
@export var IDLE : State
@export var WANDER : State
@export var SEARCHING_FOOD : State
@export var SEARCHING_BED : State
@export var SLEEPING : State
@export var EATING:  State

@export var sleep_targets : Dictionary[Enums.ObjectType, bool] = {}
@export var food_targets : Dictionary[Enums.ObjectType, bool] = {}
var busy : bool = false

#TEMP
var target: Vector2i

func _ready():
	super._ready()
	action_state_machine.init(self)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not active:
		return
	if not busy:
		choose_state()
	update_label()
		
func _process(delta: float) -> void:
	if not active:
		return
	action_state_machine.process_frame(delta)
		
func choose_state():
	if not energy.is_satisfied():
		print("NEED SLEEP, SEARCHING BED")
		action_state_machine.change_state(SEARCHING_BED)
	elif not hunger.is_satisfied():
		print("NEED FOOD, SEARCHING FOOD")
		action_state_machine.change_state(SEARCHING_FOOD)
	else:
		action_state_machine.change_state(IDLE)
		action_state = ActionStates.IDLE
	pass

func update_label():
	label.text = str("Active: ", active,
					 "\nBusy: ", busy,
					 "\nTile coords: ", tile_coords,
					 "\nState: ", ActionStates.find_key(action_state),
					 "\nHunger: ", snapped(hunger.value, 0.01), "/", hunger.max_value,
					 "\nEnergy: ", snapped(energy.value, 0.01), "/", energy.max_value)
	#active, busy, coords, hunger, energy, state


func find_target(targets: Dictionary, max_distance: int = 1) -> bool: # <- should be in a more general class for reuse
	var visited : Dictionary[Vector2i, bool] = {}
	var q : Array[Vector2i] = [tile_coords]
	var cell_details : Dictionary[Vector2i, AStarNode] = {}
	var SEARCH_RANGE : int = 2000
	var i : int = 0
	while i < SEARCH_RANGE:
		var cell : Vector2i = q.pop_front()
		if cell in visited:
			continue
		visited.set(cell, true)
		var obj : MapObject = interaction_manager.get_object(cell)
		if obj:
			if obj.ID in targets:
				##
				var start_time = Time.get_ticks_usec()
				var nearest : Dictionary = navigation_component.find_nearest(cell)
				print("Time to compute AStar: ", (Time.get_ticks_usec() - start_time)/1000, " ms")
				if cell.distance_squared_to(nearest["goal"]) <= max_distance:
					navigation_component.set_path(nearest["cell_details"], nearest["goal"])
					target = nearest["goal"]
					return true
		for dir in Util.DIRECTIONS:
			q.append(cell+dir)
		i += 1
	return false
