extends Node
class_name StateMachine

@export var starting_state : State
var current_state : State

func init(parent):
	for child in parent.state_machine.get_children():
		child.parent = parent
		#change_state(child)
	change_state(starting_state)
	
func change_state(new_state: State):
	if current_state:
		current_state.exit()
	if new_state:
		current_state = new_state
		current_state.enter()

func process_physics(delta: float):
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
		
func process_input(event: InputEvent):
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float):
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
