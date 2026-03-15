extends Node2D
class_name MapObject

@export var ID : int
@export var CATEGORY : int = Enums.ObjectCategory.DEFAULT
@export var texture : Texture2D
@onready var sprite : Sprite2D = $Sprite
@onready var hitbox = $Hitbox/CollisionShape2D
var tile_coords : Vector2i

@export var tile_footprint : Array[Vector2i] = [Vector2i(0, 0)]

func _ready():
	initialize()

func initialize():

	sprite.texture = texture
	
	# SHADERS
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://shaders/outline.gdshader")

func set_highlighted(value: bool):
	sprite.material.set_shader_parameter("enabled", value)
	
func pack() -> ObjectResource:
	var resource = ObjectResource.new()
	resource.ID = ID
	resource.tile_coords = position
	resource.CATEGORY = CATEGORY
	return resource
	
func unpack(resource: ObjectResource):
	pass

func decode(data: PackedByteArray, i: int) -> void:
	tile_coords = Vector2i(data[i+1], data[i+2])

func get_data_size() -> int:
	return 3
	
func remove():
	get_parent().remove_object(tile_coords)
	
