extends Button
class_name UIButton

const ORIGINAL_SIZE : Vector2 = Vector2(1.0, 1.0)
const UPSCALED_SIZE : Vector2 = Vector2(1.2, 1.2)
const HOVER_OFFSET : Vector2 = Vector2(-4.0, 0.0)

func _on_mouse_entered() -> void:
	scale = UPSCALED_SIZE
	position += HOVER_OFFSET

func _on_mouse_exited() -> void:
	scale = ORIGINAL_SIZE
	position -= HOVER_OFFSET
