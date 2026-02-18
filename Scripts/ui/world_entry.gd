extends HBoxContainer
class_name WorldEntry

var world_dir: String

@onready var world_name_label = $WorldName
@onready var play_button = $PlayButton

func setup(world_name: String, dir: String):
	world_dir = dir
	world_name_label.text = world_name
	
	play_button.pressed.connect(func(): load_world())

func load_world():
	print("Loading world: " , world_dir)
	var world = load("res://Scenes/core/World.tscn").instantiate()
	get_tree().root.add_child(world)
	var world_data = ResourceLoader.load(world_dir+"world_data.tres")
	world.DIR = world_dir
	print(world.DIR)
	world.WORLD_NAME = world_data.name
	world.SEED = world_data.SEED
	var player = load("res://Scenes/entities/player.tscn").instantiate()
	world.add_child(player)
	world.load_world()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world
