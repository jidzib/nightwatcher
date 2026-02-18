extends Node2D
class_name MapObject

@export var ID : int
@export var CATEGORY : int = Enums.ObjectCategory.DEFAULT
@export var texture : Texture2D
@onready var sprite : Sprite2D = $Sprite
var interactables : Dictionary
var hitbox : CollisionShape2D
var tile_coords : Vector2i

func _ready():
	initialize()

func initialize():
	#add_child(sprite)
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
