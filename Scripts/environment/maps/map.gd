extends Node2D
class_name Map

var objects: Dictionary = {}

func register(tile: Vector2i, obj):
	objects.set(tile, obj)

func remove(tile: Vector2i):
	if objects.has(tile):
		objects.erase(tile)
