extends BreakableObject
class_name GrowableObject

var current_stage : int = 0
@export var MAX_STAGE : int = 0
@export var REGION_SIZE : Vector2i = Vector2i.ZERO
@export var SPRITE_OFFSETS : Array[Vector2]
var atlas_texture : AtlasTexture = AtlasTexture.new()

func initialize():
	super.initialize()
	position -= Vector2(Util.TILE_SIZE/2, Util.TILE_SIZE/2)
	atlas_texture.atlas = sprite.texture
	atlas_texture.region = Rect2(0, 0, REGION_SIZE.x, REGION_SIZE.y)
	sprite.texture = atlas_texture
	set_stage(current_stage)
	
func set_stage(new_stage: int):
	
	current_stage = new_stage
	atlas_texture.region = Rect2(current_stage * REGION_SIZE.x, 0, REGION_SIZE.x, REGION_SIZE.y)
	sprite.texture = atlas_texture
	sprite.offset = SPRITE_OFFSETS[current_stage]
