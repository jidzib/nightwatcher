extends BreakableObject
class_name TreeObject


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Sprite2D.modulate.a = 0.5

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		$Sprite2D.modulate.a = 1.0
