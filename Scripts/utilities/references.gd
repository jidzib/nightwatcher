extends Node

var OBJECTS = {
	Enums.ObjectType.TREE : load("res://Scenes/environment/objects/Tree.tscn"),
	Enums.ObjectType.ROCK : load("res://Scenes/environment/objects/Rock.tscn")
}

var ITEMS = {
	Enums.ItemIDs.WOOD : load("res://resources/items/wood.tres"),
	Enums.ItemIDs.STONE : load("res://resources/items/stone.tres"),
	Enums.ItemIDs.HOE : load("res://resources/items/hoe.tres"),
	Enums.ItemIDs.SUNFLOWER : load("res://resources/items/sunflower.tres"),
	Enums.ItemIDs.WATER_BUCKET : load("res://resources/items/water_bucket.tres"),
	Enums.ItemIDs.AXE : load("res://resources/items/axe.tres"),
	Enums.ItemIDs.PICKAXE : load("res://resources/items/pickaxe.tres")
}
