extends BreakableObject
class_name FoliageObject

func sway():
	rotation_degrees = randf_range(-4, 4)
	var speed = randf_range(0.4, 0.6)
	var strength = randf_range(1, 2)
	
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", strength, speed)
	tween.tween_property(self, "rotation_degrees", -strength, speed)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		sway()
