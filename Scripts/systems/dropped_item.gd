extends RigidBody2D
class_name DroppedItem

@export var item: Item
@export var quantity: int = 1

@onready var sprite = $Sprite2D
var impulse_range = 60

func _ready():
	sprite.texture = item.texture
	sprite.scale = Vector2(0.5, 0.5)
	launch()
	
func _physics_process(delta: float) -> void:
	pass

func pickup(player: Player):
	player.inventory.add_item(item, quantity)
	queue_free()

func absorb(dropped_item: DroppedItem):
	quantity += dropped_item.quantity
	dropped_item.queue_free()
	
func launch():
	sleeping = false
	gravity_scale = 0.0
	apply_impulse(Vector2(randf_range(-impulse_range, impulse_range),
	 randf_range(-impulse_range, impulse_range)),
	 Vector2(randf_range(-impulse_range, impulse_range),
	randf_range(-impulse_range, impulse_range)))
	
	await get_tree().create_timer(0.2).timeout
	sleeping = true
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		pickup(body)
