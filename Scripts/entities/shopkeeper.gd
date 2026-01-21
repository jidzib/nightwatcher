extends Node2D

var player_in_range: bool = false

var player_ref: CharacterBody2D

@onready var shop = $Shop

func open():
	shop.visible = true

func _on_button_pressed() -> void:
	if player_in_range:
		open()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		player_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		player_ref = null
		shop.close_window()
