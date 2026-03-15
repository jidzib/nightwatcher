extends State

@export var using_item_state : State

func enter():
	parent.action_state = parent.ActionStates.NO_ACTION
