extends UIButton

@export var world_name : TextEdit
@export var seed_input : TextEdit
@export var size_option : OptionButton

var SIZE = { 
	WORLD_SIZES.SMALL : 128,
 	WORLD_SIZES.MEDIUM : 256,
	WORLD_SIZES.LARGE : 512,
	WORLD_SIZES.GIGANAMOSAURUS : 1024
}

enum WORLD_SIZES {
	SMALL,
	MEDIUM,
	LARGE,
	GIGANAMOSAURUS
}

func create_world():
	var world = load("uid://bycs45aiqiben").instantiate()
	world.SIZE = SIZE[size_option.get_selected_id()]
	get_tree().root.add_child(world)
	world.setup(world_name.text, int(seed_input.text))
	world.load_world()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world

func _on_pressed() -> void:
	create_world()
