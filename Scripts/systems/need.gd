extends Node
class_name Need

@export var type : Enums.NeedType
@export var value : float
@export var max_value : float
@export var threshold : float

@export var increment_amount : float
@export var decrement_amount : float

func is_satisfied() -> bool:
	return value >= threshold

func increment(delta: float) -> void:
	if value >= max_value:
		value = max_value
		return
	value += increment_amount * delta

func decrement(delta: float) -> void:
	if value <= 0:
		value = 0
		return
	value -= decrement_amount * delta

func _process(delta: float) -> void:
	decrement(delta)
