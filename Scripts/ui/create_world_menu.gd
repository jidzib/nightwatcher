extends Control

@onready var world_name = $VBoxContainer/WorldName
@onready var seed_input = $VBoxContainer/SeedInput

func create_world():
	var world = load("res://Scenes/core/World.tscn").instantiate()
	get_tree().root.add_child(world)
	world.setup(world_name.text, int(seed_input.text))
	var player = load("res://Scenes/entities/player.tscn").instantiate()
	world.add_child(player)
	world.load_world()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world
