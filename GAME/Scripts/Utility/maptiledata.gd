class_name MapTileData extends Resource

enum LayoutTypes {
	OPEN_LEFT,
	OPEN_MIDDLE,
	OPEN_RIGHT
}

@export var entrance_type: LayoutTypes
@export var exit_type: LayoutTypes
@export var tile_scene: PackedScene
