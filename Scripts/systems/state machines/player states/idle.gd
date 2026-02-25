extends State

@export var walk_state : State

func enter() -> void:
	print("Entered idle state")
	parent.animated_sprite.play("idle")
	parent.state = parent.States.IDLE
	
func process_physics(delta: float) -> State:
	if parent.movement != Vector2.ZERO:
		return walk_state
	return null
	
