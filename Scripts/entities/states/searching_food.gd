extends State

#@export var carnivore : bool = false
#
#func search_prey():
	#pass
#
#func search_harvest():
	#pass

var search_range : int = 20
@export var timer : Timer

@export var MAX_TARGET_DISTANCE : int = 1

func enter() -> void:
	parent.action_state = parent.ActionStates.SEARCHING_FOOD
	parent.busy = true
	if not parent.find_target(parent.food_targets, MAX_TARGET_DISTANCE):
		print("Couldn't find target")
		wait_then_exit()
		return
	loop()

func loop():
	await get_tree().create_timer(5.0).timeout
	if not parent.find_target(parent.food_targets, MAX_TARGET_DISTANCE):
		wait_then_exit()
	if parent.action_state != parent.ActionStates.SEARCHING_FOOD:
		return
	loop()

func wait_then_exit():
	parent.navigation_component.path = []
	timer.start()
	await timer.timeout
	parent.busy = false
	parent.action_state_machine.change_state(parent.IDLE)

func process_frame(delta: float) -> State:
	if parent.target and parent.tile_coords.distance_to(parent.target) < MAX_TARGET_DISTANCE:
		parent.action_state_machine.change_state(parent.EATING)
	return null
