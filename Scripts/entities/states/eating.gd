extends State

func enter() -> void:
	parent.action_state = parent.ActionStates.EATING
	
func process_frame(delta: float) -> State:
	parent.hunger.increment(delta)
	if parent.hunger.value >= parent.energy.max_value:
		print("Got enough sleep")
		parent.action_state_machine.change_state(parent.IDLE)
	return null
