extends State

func enter() -> void:
	parent.animation_player.play("idle")
	parent.action_state = parent.ActionStates.IDLE
	parent.busy = false
	
func process_frame(delta: float) -> State:
	return null
