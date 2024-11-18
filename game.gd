extends Node3D
class_name Game

enum GameStates {
	WAITING,
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
static var objects_hit := 0
var cons_alcool=		[0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00]
var cons_aclcool_fac=	[0.00,0.00,0.10,0.10,0.15,0.15,0.15,0.15,0.15,0.15,0.15,0.15,0.10,0.10]
var alcool_absorbtion :=0.05
var tauxalcool := 0.0
var time :=0.0
static var game_state: GameStates = GameStates.WAITING

const fac_time =1
const tile_length = 30
const map_length = 1

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
	cons_alcool[0]+=1
	hud.update_alcohol(alcohol_collected)

func _on_object_hit() -> void:
	objects_hit+=1
	hud.update_obects(objects_hit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_generator.generate_map(map_length)
	Car.get_child(0).alcohol_collected.connect(_on_alcohol_collected)
	Car.get_child(0).end_reached.connect(_on_end_reached)
	Car.get_child(0).object_hit.connect(_on_object_hit)
	Engine.time_scale = 1
	game_state = GameStates.WAITING 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_state != GameStates.PLAYING:
		return 

	time+=delta*fac_time;
	if time>1.0:
		time=fmod(time,1.0)
		RenderingServer.global_shader_parameter_set("tauxalcool",tauxalcool);
	RenderingServer.global_shader_parameter_set("time",time);

func _on_end_reached() -> void:
	game_state = GameStates.FINISHED
	RenderingServer.global_shader_parameter_set("tauxalcool",0);
	Engine.time_scale = 0
	hud.visible = false
	add_child(endScreenScene.instantiate())

func _on_aclool_timer_timeout() -> void:
	tauxalcool-=alcool_absorbtion
	if tauxalcool<0.0:
		tauxalcool=0.0
	for i in range(cons_alcool.size()):
		tauxalcool += cons_alcool[i] * cons_aclcool_fac[i]
	for i in range(cons_alcool.size()-1,0,-1):
		cons_alcool[i] = cons_alcool[i-1]
	cons_alcool[0]=0.0

func free() -> void:
	Engine.time_scale = 1
