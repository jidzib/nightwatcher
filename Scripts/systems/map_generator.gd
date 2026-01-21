extends Node2D
class_name MapGenerator

@export var noise_texture: NoiseTexture2D
@export var tree_noise_texture: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var width: int
var height: int

var TILE_SIZE: int = 16

@onready var grass_tilemap = $GrassLayer
var GRASS_ID: int = 0
var GRASS: Vector2i = Vector2i(0, 0)

var TREE = preload("res://Scenes/TreeObject.tscn")
var ROCK = preload("res://Scenes/RockObject.tscn")

func _ready():
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise
	width = noise_texture.width
	height = noise_texture.height

func generate_world(map):
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x, y)
			var tree_noise_val = tree_noise.get_noise_2d(x, y)
			if tree_noise_val > 0.5:
				var new_tree = TREE.instantiate()
				new_tree.position = Vector2(x*TILE_SIZE-8, y*TILE_SIZE-8)
				map.BREAKABLE.add_child(new_tree)
			if tree_noise_val < -0.4:
				var new_rock = ROCK.instantiate()
				new_rock.position = Vector2(x*TILE_SIZE-8, y*TILE_SIZE-8)
				map.BREAKABLE.add_child(new_rock)
			map.GRASS.set_cell(Vector2i(x, y), GRASS_ID, GRASS)
		
