extends Node3D

@onready var map_generator: MapGenerator = %MapGenerator
@onready var Car: Node3D = $car
@onready var hud: CanvasLayer = $Hud

var current_tile_ends = Vector2(1,1)
var current_tile_pos = Vector3(0,0,0)
var alcohol_collected := 0

const tile_length = 30
const map_length = 5

func choose_next_tile(current: Vector2) -> Vector2:
	var next_end = randi()%3
	return Vector2(current.y, next_end)
	
func _create_tile(tile: PackedScene) -> void:
	var new_tile: Node3D = tile.instantiate()
	new_tile.position = current_tile_pos
	current_tile_pos.x += tile_length
	add_child(new_tile)

func _on_alcohol_collected() -> void:
	alcohol_collected+=1
	hud.update_alcohol(alcohol_collected)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_generator.generate_map(map_length)
	Car.get_child(0).alcohol_collected.connect(_on_alcohol_collected)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
