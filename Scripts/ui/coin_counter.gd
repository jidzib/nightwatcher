extends Control

var count: int = 0
@onready var displayed_count: Label = $Label

func update_count(amount: int):
	count += amount
	displayed_count.text = str(count)
func _on_tree_entered() -> void:
	GlobalSignal.update_player_coins.connect(update_count)
func _on_tree_exited() -> void:
	GlobalSignal.update_player_coins.disconnect(update_count)
