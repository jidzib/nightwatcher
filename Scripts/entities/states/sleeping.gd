extends State

func enter() -> void:
	print("entered sleeping state")
	parent.animation_player.play("sleep")
	parent.action_state = parent.ActionStates.SLEEPING
	parent.animation_locked = true
	parent.navigation_component.path = []
	parent.stop_moving()

func process_frame(delta: float) -> State:
	parent.energy.increment(delta)
	if parent.energy.value >= parent.energy.max_value:
		print("Got enough sleep")
		parent.action_state_machine.change_state(parent.IDLE)
	return null
	
func exit() -> void:
	parent.animation_locked = false
	parent.busy = false
	print("DONE SLEEPING")
