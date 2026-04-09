extends Node
class_name AStarNode

var pos : Vector2i
var parent_pos : Vector2i
var g : int
var h : int
var f : int

func _init(_pos: Vector2i, _g: int, _h: int, _parent_pos: Vector2i) -> void:
	pos = _pos
	g = _g
	h = _h
	f = g + h
	parent_pos = _parent_pos
