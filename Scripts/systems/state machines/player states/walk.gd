extends State

@export var idle_state : State

func enter() -> void:
	print("Entered walk state")
	parent.animated_sprite.play("walk")
	parent.state = parent.States.WALK

func process_physics(delta: float) -> State:
	
	if parent.movement == Vector2.ZERO:
		return idle_state
		
	return null

func process_input(event: InputEvent) -> State:
	
	if event.is_action_pressed("roll"):
		roll()
	
	return null

func roll():
	parent.speed = 160
	var sign = signf(parent.movement.x) if abs(parent.movement.x) > abs(parent.movement.y) else signf(parent.movement.y)
	
	var duration = 0.5
	parent.animated_sprite.rotation = 0.0
	var tween := create_tween()

	tween.tween_property(
		parent.animated_sprite,
		"rotation",
		sign * TAU,
		duration
	)
	await get_tree().create_timer(0.5).timeout
	parent.speed = 80
