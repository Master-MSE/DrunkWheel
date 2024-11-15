extends Node3D
class_name Game

enum GameStates {
	PLAYING,
	FINISHED
}

@onready var map_generator: MapGenerator = %MapGenerator
@onready var Car: Node3D = $car
@onready var hud: CanvasLayer = $Hud

@export var endScreenScene: PackedScene

var current_tile_ends = Vector2(1,1)
var current_tile_pos = Vector3(0,0,0)
static var alcohol_collected := 0
var drinks = []
class drink:
	var alcool=0.0
	var time_cons=0.0
var alcool_absorbtion :=0.4
var tauxalcool := 0.0
var pik_time_alcool=5.0
var time :=0.0
static var game_state: GameStates


const fac_time =1
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
	#cons_alcool[0]+=1
	var drink_o = drink.new()
	drink_o.alcool=1.0
	drink_o.time_cons=time
	drinks.append(drink_o)
	hud.update_alcohol(alcohol_collected)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_generator.generate_map(map_length)
	Car.get_child(0).alcohol_collected.connect(_on_alcohol_collected)
	Car.get_child(0).end_reached.connect(_on_end_reached)
	Engine.time_scale = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	cal_taux_alcool()
	RenderingServer.global_shader_parameter_set("time",time);

func _on_end_reached() -> void:
	game_state = GameStates.FINISHED
	Engine.time_scale = 0
	add_child(endScreenScene.instantiate())
	
func cal_taux_alcool():
	tauxalcool=0.0
	var new_drinks=[]
	for drink_o in drinks:
		var one_drink_taux=0.0
		var time_diff=time-drink_o.time_cons
		if (time_diff<pik_time_alcool):
			one_drink_taux=drink_o.alcool * (time_diff / pik_time_alcool)
			tauxalcool+=one_drink_taux
			new_drinks.append(drink_o)
		else:
			one_drink_taux=drink_o.alcool -alcool_absorbtion*((time_diff / pik_time_alcool)-1.0)
			if (one_drink_taux>0):
				tauxalcool+=one_drink_taux
				new_drinks.append(drink_o)
	drinks=new_drinks		
	RenderingServer.global_shader_parameter_set("tauxalcool",tauxalcool);
	
func free() -> void:
	Engine.time_scale = 1
