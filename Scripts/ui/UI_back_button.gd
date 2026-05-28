extends UIButton
class_name UIBackButton

func _on_pressed() -> void:
	GlobalSignal.ui_back_request.emit()
