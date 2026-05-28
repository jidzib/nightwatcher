extends State

var search_range : int = 20
@export var timer : Timer

@export var MAX_TARGET_DISTANCE : int = 1

func enter() -> void:
	parent.action_state = parent.ActionStates.SEARCHING_BED
	parent.busy = true
	if not parent.find_target(parent.sleep_targets, MAX_TARGET_DISTANCE):
		print("Couldn't find target")
		wait_then_exit()
		return
	loop()

func loop():
	await get_tree().create_timer(5.0).timeout
	if not parent.find_target(parent.sleep_targets, MAX_TARGET_DISTANCE):
		wait_then_exit()
	if parent.action_state != parent.ActionStates.SEARCHING_BED:
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
		parent.action_state_machine.change_state(parent.SLEEPING)
	return null
