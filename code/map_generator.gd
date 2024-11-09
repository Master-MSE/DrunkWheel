extends Node
class_name MapGenerator

@export var map_tile_datas: Array[MapTileData]
var current_tile_ends = Vector2(1,1)
var current_tile_pos = Vector3(30,0,0)

func pick_tile(entrance_type: MapTileData.LayoutTypes) -> MapTileData:
	print(map_tile_datas)
	var filtered_tiledata := map_tile_datas.filter(func(t: MapTileData) : return t.entrance_type == entrance_type)
	return filtered_tiledata.pick_random()

func generate_map(map_length: int) -> void:
	
	var current_exit_type: MapTileData.LayoutTypes = MapTileData.LayoutTypes.OPEN_MIDDLE
	
	for i in map_length:
		var tile := pick_tile(current_exit_type)
		current_exit_type = tile.exit_type
		var tile_scene: Node3D = tile.tile_scene.instantiate()
		
		tile_scene.position = current_tile_pos
		current_tile_pos.x += 30
		add_child(tile_scene)
