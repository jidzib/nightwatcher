extends BreakableObject
class_name TreeObject

@onready var vision_box : Area2D = $VisionBox

func _ready():
	initialize()

func _on_vision_box_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		sprite.modulate.a = 0.6

func _on_vision_box_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		sprite.modulate.a = 1.0
