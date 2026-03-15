extends State

@export var walk_state : State

@export var using_item_state : State

func enter() -> void:
	print("Entered idle state")
	parent.movement_state = parent.MovementStates.IDLE
	
func process_physics(delta: float) -> State:
	if parent.movement != Vector2.ZERO:
		return walk_state
	return null
	
