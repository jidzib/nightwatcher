extends BreakableObject
class_name TreeObject

@onready var vision_box : Area2D = $VisionBox

func _ready():
	initialize()
	sway()
	

func _on_vision_box_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		sprite.self_modulate.a = 0.6

func _on_vision_box_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		sprite.self_modulate.a = 1.0
		
func sway():
	rotation_degrees = randf_range(-0.2, 0.2)
	var speed = randf_range(2.0, 2.2)
	var strength = randf_range(0, 1)
	
	var tween = create_tween().set_loops()
	tween.tween_property(self, "rotation_degrees", strength, speed)
	tween.tween_property(self, "rotation_degrees", -strength, speed)
