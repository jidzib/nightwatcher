extends MapObject
class_name CropObject

@export var crop_resource: CropResource
var crop_sprite := Sprite2D.new()
var shader: Shader = preload("res://shaders/crop.gdshader")
var outline := Sprite2D.new()

var stage: int = 0
var watered: bool = false
var water_overlay := Sprite2D.new()
var stage_textures: Array[AtlasTexture] = []
var selected: bool = false

const TEXTURE_ROW_LENGTH: int = 4

func _ready():
	# Load sprite texture coords per stage
	for i in range(crop_resource.max_stage):
		var atlas = AtlasTexture.new()
		atlas.atlas = crop_resource.texture
		atlas.region = Rect2(
			i % TEXTURE_ROW_LENGTH * TILE_SIZE,
			floor(i/TEXTURE_ROW_LENGTH) * TILE_SIZE,
			TILE_SIZE,
			TILE_SIZE
		)
		stage_textures.append(atlas)
	initialize_shaders()
	set_sprite()
	#crop_sprite.z_index = 1
	z_index = 0
	y_sort_enabled = true	
	outline.z_index = 1
	water_overlay.z_index = 2
	add_child(crop_sprite)
	add_child(outline)
	
	# Load water overlay
	water_overlay.texture = preload("res://assets/tiles/water_overlay.png")
	water_overlay.visible = false
	add_child(water_overlay)
	
	initialize_to_map()

func set_type():
	obj_type = Enums.ObjectType.CROP

func set_interactables():
	INTERACTABLE.set(Enums.ItemType.HOE, null)
	INTERACTABLE.set(Enums.ItemType.WATER_BUCKET, null)
		
func initialize_shaders():
	crop_sprite.material = ShaderMaterial.new()
	crop_sprite.material.shader = shader
	crop_sprite.material.set_shader_parameter("skew", 0)
	outline.material = ShaderMaterial.new()
	outline.material.shader = shader
	outline.material.set_shader_parameter("skew", 0)
	
func set_sprite():
	crop_sprite.texture = stage_textures[stage]
	set_outline()
	if stage >= 2: # <- can move this to a blank function and adjust for different crop types
		crop_sprite.position.y -= 3
		outline.position.y -= 3
		
func set_outline():
	var thickness = 1
	var outline_color = Color.WHITE
	if not selected:
		outline.texture = null
		return
	var img = crop_sprite.texture.get_image()
	img.convert(Image.FORMAT_RGBA8)

	var w = img.get_width()
	var h = img.get_height()

	var out_img = Image.create(w + thickness * 2, h + thickness * 2, false, Image.FORMAT_RGBA8)

	for x in range(w):
		for y in range(h):
			var a = img.get_pixel(x, y).a
			if a > 0.01:
				for ox in range(-thickness, thickness + 1):
					for oy in range(-thickness, thickness + 1):
						out_img.set_pixel(x + ox + thickness, y + oy + thickness, outline_color)
	outline.texture = ImageTexture.create_from_image(out_img)
	
func select():
	selected = true
	set_outline()
func deselect():
	selected = false
	set_outline()

var skew_value = 4
var bend_speed = 0.1
var return_speed = 4.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if stage > 0 and body.has_method("player"):
		var dir = global_position.direction_to(body.global_position)
		var skew : int = -dir.x * skew_value
		
		var tween = create_tween()
		tween.tween_property(
			crop_sprite.material,
			"shader_parameter/skew",
			skew,
			bend_speed
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
		tween.tween_property(
			crop_sprite.material,
			"shader_parameter/skew",
			0.0,
			return_speed
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
