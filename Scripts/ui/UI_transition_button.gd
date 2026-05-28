extends UIButton
class_name UITransitionButton

@export var destination : Enums.UIType

func _on_pressed() -> void:
	GlobalSignal.ui_transition_request.emit(References.UIs[destination].instantiate())
