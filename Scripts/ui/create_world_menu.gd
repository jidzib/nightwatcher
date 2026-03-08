extends Control

@onready var world_name = $VBoxContainer/NameContainer/NameInput
@onready var seed_input = $VBoxContainer/SeedContainer/SeedInput
@onready var size_option = $VBoxContainer/SizeContainer/SizeInput

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
	var world = load("res://Scenes/core/World.tscn").instantiate()
	world.SIZE = SIZE[size_option.get_selected_id()]
	get_tree().root.add_child(world)
	world.setup(world_name.text, int(seed_input.text))
	world.load_world()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world
