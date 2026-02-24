extends Control

@onready var world_name = $VBoxContainer/NameContainer/NameInput
@onready var seed_input = $VBoxContainer/SeedContainer/SeedInput

func create_world():
	var world = load("res://Scenes/core/World.tscn").instantiate()
	get_tree().root.add_child(world)
	world.setup(world_name.text, int(seed_input.text))
	world.load_world()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world
