extends Node2D
class_name MapObject

@export var ID : int
@export var CATEGORY : int = Enums.ObjectCategory.DEFAULT
@export var texture : Texture2D
@onready var sprite : Sprite2D = $Sprite
@export var hitbox : CollisionShape2D
var tile_coords : Vector2i
@export var tile_footprint : Array[Vector2i] = [Vector2i(0, 0)]
@export var is_collider : bool = true

func _ready():
	initialize()
	position += Vector2(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	
func initialize():

	sprite.texture = texture
	#sprite.y_sort_enabled = true
	# SHADERS
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://shaders/outline.gdshader")

func set_highlighted(value: bool):
	sprite.material.set_shader_parameter("enabled", value)

func encode(data: PackedByteArray) -> void:
	var chunk_coords : Vector2i = Util.get_chunk_from_tile(tile_coords)
	var local_coords : Vector2i = tile_coords - chunk_coords * Util.CHUNK_SIZE
	data.append(ID)
	data.append(local_coords.x)
	data.append(local_coords.y)
	
func decode(data: PackedByteArray, i: int) -> void:
	tile_coords = Vector2i(data[i+1], data[i+2])

func spawn_runtime_dependencies(_refs):
	pass

func get_data_size() -> int:
	return 3
	
func remove():
	get_parent().remove_object(tile_coords)
	
