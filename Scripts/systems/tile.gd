extends Node2D
class_name Tile

# Needs shader
var tile_coords: Vector2
var sprite := Sprite2D.new()

func _ready() -> void:
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.modulate.a = 0.3
	add_child(sprite)
	
func can_interact_with(item: Item) -> bool:
	return false
	
func select():
	pass
func deselect():
	queue_free()
