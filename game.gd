extends Node3D

var start_tile:PackedScene = preload("res://map/start_tile.tscn")
var end_tile:PackedScene = preload("res://map/end_tile.tscn")
var tile_0_0:PackedScene = preload("res://map/tile_0_0.tscn")
var tile_0_1:PackedScene = preload("res://map/tile_0_1.tscn")
var tile_0_2:PackedScene = preload("res://map/tile_0_2.tscn")
var tile_1_0:PackedScene = preload("res://map/tile_1_0.tscn")
var tile_1_1:PackedScene = preload("res://map/tile_1_1.tscn")
var tile_1_2:PackedScene = preload("res://map/tile_1_2.tscn")
var tile_2_0:PackedScene = preload("res://map/tile_2_0.tscn")
var tile_2_1:PackedScene = preload("res://map/tile_2_1.tscn")
var tile_2_2:PackedScene = preload("res://map/tile_2_2.tscn")

var tiles := [
	[tile_0_0, tile_0_1, tile_0_2],
	[tile_1_0, tile_1_1, tile_1_2],
	[tile_2_0, tile_2_1, tile_2_2]
]

var current_tile_ends = Vector2(1,1)
var current_tile_pos = Vector3(0,0,0)

const tile_length = 30
const map_length = 10

func choose_next_tile(current: Vector2) -> Vector2:
	var next_end = randi()%3
	return Vector2(current.y, next_end)
	
func _create_tile(tile: PackedScene) -> void:
	var new_tile: Node3D = tile.instantiate()
	new_tile.position = current_tile_pos
	current_tile_pos.x += tile_length
	add_child(new_tile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# initial tile
	_create_tile(start_tile)
	
	for i in map_length:
		current_tile_ends = choose_next_tile(current_tile_ends)
		_create_tile(tiles[current_tile_ends.x][current_tile_ends.y])
	
	_create_tile(end_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
