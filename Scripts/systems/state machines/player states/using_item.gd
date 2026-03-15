extends State

@export var default_state : State

func enter():
	parent.action_state = parent.ActionStates.USING_ITEM
	swing()
	
func swing():

	parent.animation_tree.set("parameters/Swinging/blend_position", 1.0)
	parent.animation_tree.set("parameters/Add2/add_amount", 1.0)
	camera_shake()
	await get_tree().create_timer(0.60).timeout

	parent.animation_tree.set("parameters/Swinging/blend_position", 0.0)
	parent.animation_tree.set("parameters/Add2/add_amount", 0.0)
	
	parent.action_state_machine.change_state(default_state)
	
	
func camera_shake():
	var tween = create_tween()
	var shake : int = 1
	var duration : float = 0.05
	
	tween.tween_property(parent.camera, "offset", Vector2(-shake, -shake), duration)
	tween.tween_property(parent.camera, "offset", Vector2(shake, shake), duration)
	tween.tween_property(parent.camera, "offset", Vector2(), duration)
	tween.tween_property(parent.camera, "offset", Vector2(shake, -shake), duration)
	tween.tween_property(parent.camera, "offset", Vector2(-shake, shake), duration)
	tween.tween_property(parent.camera, "offset", Vector2(), duration)
