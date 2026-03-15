extends BreakableObject
class_name GrowableObject

var current_stage : int = 0
@export var MAX_STAGE : int = 0
@export var REGION_SIZE : Vector2i = Vector2i.ZERO
var atlas_texture : AtlasTexture = AtlasTexture.new()

func _ready():
	initialize()
	growable_setup()
	
func growable_setup():
	atlas_texture.atlas = texture
	atlas_texture.region = Rect2(0, 0, REGION_SIZE.x, REGION_SIZE.y)
	sprite.texture = atlas_texture
	
func set_stage(new_stage: int):
	
	current_stage = new_stage
	atlas_texture.region = Rect2(current_stage * REGION_SIZE.x, 0, REGION_SIZE.x, REGION_SIZE.y)
	sprite.texture = atlas_texture
