extends Resource
class_name ChunkData

@export var objects: Dictionary[Vector2i, ObjectResource] 

@export var object_data : PackedByteArray

@export var tile_ids: PackedByteArray
@export var tile_atlas_x: PackedByteArray
@export var tile_atlas_y: PackedByteArray
@export var pos_x: PackedByteArray # tilepos
@export var pos_y: PackedByteArray # tilepos
