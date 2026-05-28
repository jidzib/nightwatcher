extends HBoxContainer
class_name WorldEntry

var world_dir: String

@onready var world_name_label = $WorldName
@export var play_button : UIButton

func setup(world_name: String, dir: String):
	world_dir = dir
	world_name_label.text = world_name
	world_name_label.add_theme_font_override("font", load("res://assets/fonts/Retro Gaming.ttf"))
	#play_button.add_theme_font_override("font", load("res://assets/fonts/Retro Gaming.ttf"))
	play_button.pressed.connect(func(): load_world())

func load_world():
	print("Loading world: " , world_dir)
	var world = load("res://Scenes/core/World.tscn").instantiate()
	get_tree().root.add_child(world)
	var world_data = ResourceLoader.load(world_dir+"world_data.tres")
	world.DIR = world_dir
	world.WORLD_NAME = world_data.name
	world.SEED = world_data.SEED
	world.load_world()
	Util.switch_scene(world)
