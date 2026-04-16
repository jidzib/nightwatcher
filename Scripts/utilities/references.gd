extends Node

var OBJECTS = {
	Enums.ObjectType.FOREST_TREE : preload("res://Scenes/environment/objects/ForestTree.tscn"),
	Enums.ObjectType.ROCK : preload("res://Scenes/environment/objects/Rock.tscn"),
	Enums.ObjectType.FOLIAGE : preload("res://Scenes/environment/objects/Foliage.tscn"),
	Enums.ObjectType.SUNFLOWER : preload("res://Scenes/environment/objects/Sunflower.tscn"),
	Enums.ObjectType.FARMLAND : preload("res://Scenes/environment/objects/Farmland.tscn"),
	Enums.ObjectType.JUNGLE_TREE : preload("res://Scenes/environment/objects/JungleTree.tscn"),
	Enums.ObjectType.CACTUS : preload("res://Scenes/environment/objects/Cactus.tscn"),
	Enums.ObjectType.SNOW_TREE : preload("res://Scenes/environment/objects/SnowTree.tscn")
}

var ITEMS = {
	Enums.ItemIDs.WOOD : load("res://resources/items/wood.tres"),
	Enums.ItemIDs.STONE : load("res://resources/items/stone.tres"),
	Enums.ItemIDs.HOE : load("res://resources/items/hoe.tres"),
	Enums.ItemIDs.SUNFLOWER : load("res://resources/items/sunflower.tres"),
	Enums.ItemIDs.WATER_BUCKET : load("res://resources/items/water_bucket.tres"),
	Enums.ItemIDs.AXE : load("res://resources/items/axe.tres"),
	Enums.ItemIDs.PICKAXE : load("res://resources/items/pickaxe.tres"),
	Enums.ItemIDs.DEV_TREE : load("res://resources/items/dev items/dev_tree.tres"),
	Enums.ItemIDs.DEV_ROCK : load("res://resources/items/dev items/dev_rock.tres"),
	Enums.ItemIDs.SUNFLOWER_SEEDS : load("res://resources/items/sunflower_seeds.tres")
}
