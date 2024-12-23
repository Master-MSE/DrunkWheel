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
@onready var timer: Timer = $aclool_timer
@onready var control: Control = $StartMenu

@onready var sd_game:AudioStreamPlayer = $sound/game_sound
@onready var sd_drink:AudioStreamPlayer = $sound/drink_sound
@onready var sd_drink2:AudioStreamPlayer = $sound/drink_sound2
@onready var sd_bump:AudioStreamPlayer = $sound/bump_sound
@onready var sd_shoot:AudioStreamPlayer = $sound/shoot_sound
@onready var sd_menu:AudioStreamPlayer = $sound/menu_sound
@onready var sd_end1:AudioStreamPlayer = $sound/end1_sound
@onready var sd_end2:AudioStreamPlayer = $sound/end2_sound
@onready var sd_level:AudioStreamPlayer = $sound/level_sound




@export var endScreenScene: PackedScene

const pik_time_alcool=10.0
const alcool_absorbtion :=0.025
const fac_time =1
const tile_length = 30
const map_length = 1

static var game_state: GameStates = GameStates.WAITING
static var alcohol_collected := 0
static var objects_hit := 0

var current_tile_ends = Vector2(1,1)
var current_tile_pos = Vector3(0,0,0)
var drinks = []
class drink:
	var alcool=0.0
	var time_cons=0.0
	var abs_actuel=0.0
var tauxalcool := 0.0
var time :=0.0
var end_scene


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
	drink_o.abs_actuel=0.0
	drinks.append(drink_o)
	if not sd_drink.playing and not sd_drink2.playing and not sd_level.playing:
		var rand=randi()%4
		var audio_stream
		if rand==0:
			audio_stream = load("res://GAME/Assets/Audio/GetDrink1.wav")
		elif rand==1:
			audio_stream = load("res://GAME/Assets/Audio/GetDrink2.wav")
		elif rand==2:
			audio_stream = load("res://GAME/Assets/Audio/GetDrink3.wav")
		else:
			audio_stream = load("res://GAME/Assets/Audio/GetDrink4.wav")
		sd_drink.stream=audio_stream
		sd_drink.play()

func _on_object_hit() -> void:
	sd_bump.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport = Viewport
	map_generator.generate_map(map_length)
	control.start.connect(sound_finished)
	Car.get_child(0).alcohol_collected.connect(_on_alcohol_collected)
	Car.get_child(0).end_reached.connect(_on_end_reached)
	Car.get_child(0).object_hit.connect(_on_object_hit)
	GlobalSignal.shoot.connect(sound_shoot_effect)
	Engine.time_scale = 1
	update_shader_screen_size()
	get_tree().get_root().size_changed.connect(update_shader_screen_size)
	game_state = GameStates.WAITING 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match (game_state):
		GameStates.WAITING:
			hud.visible=false
			if !sd_menu.playing:
				sd_menu.play()
				sd_game.stop()
				sd_end1.stop()
				sd_end2.stop()
		GameStates.PLAYING:
			hud.visible=true
			hud.update_taux(tauxalcool)
			time+=delta
			cal_taux_alcool(delta)
			if !sd_game.playing:
				sd_menu.stop()
				sd_game.play()
				sd_end1.stop()
				sd_end2.stop()
		GameStates.FINISHED:
			hud.visible=false
			sd_menu.stop()
			sd_game.stop()
			if !sd_end1.playing:
				if !sd_end2.playing:
					sd_end2.play()

func _on_end_reached() -> void:
	game_state = GameStates.FINISHED
	RenderingServer.global_shader_parameter_set("tauxalcool",0);
	#Engine.time_scale = 0
	hud.visible = false
	$timer_screan.start()
	print(CollisionHandler.get_registered_collisions())
	print(CollisionHandler.get_collision_prices())
	sd_end1.play()
	
func _on_timer_screan_timeout() -> void:
	end_scene = endScreenScene.instantiate()
	add_child(end_scene)
	end_scene.restart_game.connect(_on_restart_game)
	
	
func cal_taux_alcool(delta:float):
	tauxalcool=0.0
	var new_drinks=[]
	for drink_o in drinks:
		var one_drink_taux=0.0
		var time_diff=time-drink_o.time_cons
		if (time_diff<pik_time_alcool):
			drink_o.abs_actuel=drink_o.alcool * (time_diff / pik_time_alcool)
			#one_drink_taux=drink_o.alcool * (time_diff / pik_time_alcool)
			tauxalcool+=drink_o.abs_actuel
			new_drinks.append(drink_o)
		else:
			drink_o.abs_actuel= drink_o.abs_actuel -alcool_absorbtion*delta/drinks.size()
			#one_drink_taux=drink_o.alcool -alcool_absorbtion*((time_diff / pik_time_alcool)-1.0)/drinks.size()
			if (drink_o.abs_actuel>0):
				tauxalcool+=drink_o.abs_actuel
				new_drinks.append(drink_o)
	drinks=new_drinks		
	RenderingServer.global_shader_parameter_set("tauxalcool",tauxalcool);
	update_game_sound()
	
func update_game_sound():
	var audio_game=AudioServer.get_bus_index("game_sound")
	var phaser_effect  =AudioServer.get_bus_effect(audio_game,0)
	var panner_effect  =AudioServer.get_bus_effect(audio_game,1)
	var feedback_val=clamp(tauxalcool*0.09, 0.0, 0.9);
	panner_effect.pan = 	feedback_val*sin(time*2.0/5.0*PI)
	if feedback_val <= 0.1 :
		AudioServer.set_bus_effect_enabled(audio_game,0,false)
	else :
		AudioServer.set_bus_effect_enabled(audio_game,0,true)
	phaser_effect.feedback = feedback_val
	
func free() -> void:
	Engine.time_scale = 1

func _on_restart_game() -> void:
	game_state = GameStates.WAITING
	CollisionHandler.reset()
	alcohol_collected = 0
	objects_hit = 0
	tauxalcool = 0.0
	time =0.0
	if is_instance_valid(end_scene):
		end_scene.queue_free()
		end_scene=null
	Car.get_child(0).hitted_objects.clear()
	get_tree().reload_current_scene()
	
func update_shader_screen_size():
	var screen_size = get_viewport().get_size()
	hud.updadte_affichage(screen_size)
	control.updadte_affichage(screen_size)
	if is_instance_valid(end_scene):
		end_scene.updadte_affichage(screen_size)
	RenderingServer.global_shader_parameter_set("screen_size",screen_size);

func play_taux_alcool_sound():
	if sd_level.playing:
		pass
	elif sd_drink.playing or sd_drink2.playing :
		timer.wait_time=1
		timer.start()
	else :
		var rand=randi()%3
		var rand2=randi()%4
		var audio_stream
		if tauxalcool<2.5:
			if rand==1:
				audio_stream = load("res://GAME/Assets/Audio/Level0_1.wav")
			elif rand==2:
				audio_stream = load("res://GAME/Assets/Audio/Level0_2.wav")
			else:
				audio_stream = load("res://GAME/Assets/Audio/Level0_3.wav")
		elif  tauxalcool<5.0:
			if rand==1:
				audio_stream = load("res://GAME/Assets/Audio/Level1_1.wav")
			elif rand==2:
				audio_stream = load("res://GAME/Assets/Audio/Level1_2.wav")
			else:
				audio_stream = load("res://GAME/Assets/Audio/Level1_3.wav")
		elif tauxalcool<7.5:
			if rand==1:
				audio_stream = load("res://GAME/Assets/Audio/Level2_1.wav")
			elif rand==2:
				audio_stream = load("res://GAME/Assets/Audio/Level2_2.wav")
			else:
				audio_stream = load("res://GAME/Assets/Audio/Level2_3.wav")
		elif tauxalcool<10.0:
			if rand==1:
				audio_stream = load("res://GAME/Assets/Audio/Level3_1.wav")
			elif rand==2:
				audio_stream = load("res://GAME/Assets/Audio/Level3_2.wav")
			else:
				audio_stream = load("res://GAME/Assets/Audio/Level3_3.wav")
		else:
			if rand2==1:
				audio_stream = load("res://GAME/Assets/Audio/Level4_1.wav")
			elif rand2==2:
				audio_stream = load("res://GAME/Assets/Audio/Level4_2.wav")
			elif rand2==3:
				audio_stream = load("res://GAME/Assets/Audio/Level4_3.wav")
			else:
				audio_stream = load("res://GAME/Assets/Audio/Level4_4.wav")
		sd_level.stream = audio_stream
		sd_level.play()
func _on_aclool_timer_timeout() -> void:
	if game_state == GameStates.PLAYING:
		play_taux_alcool_sound()

func sound_finished() -> void:
	var wait_time=randf()*10.0+5.0
	timer.wait_time=wait_time
	timer.start()


func _on_drink_sound_finished() -> void:
	var rand=randi()%4
	var audio_stream
	if rand==0:
		audio_stream = load("res://GAME/Assets/Audio/BeerOpening/beer-can-open-sound-230903.mp3")
	elif rand==1:
		audio_stream = load("res://GAME/Assets/Audio/BeerOpening/beer-can-opening-140383.mp3")
	elif rand==2:
		audio_stream = load("res://GAME/Assets/Audio/BeerOpening/beer-can-opening-hq-wav-268272.mp3")
	else:
		audio_stream = load("res://GAME/Assets/Audio/BeerOpening/can-opening-fizzy-drink-soda-pop-high-quality-96655.mp3")
	sd_drink2.stream=audio_stream
	sd_drink2.play()
	
func sound_shoot_effect(type)-> void:
	var audio_stream
	if type==0:
		audio_stream = load("res://GAME/Assets/Audio/man-scream.wav")
	elif type==1:
		audio_stream = load("res://GAME/Assets/Audio/dog.wav")
	else:
		audio_stream = load("res://GAME/Assets/Audio/woman-scream.wav")
	sd_shoot.stream=audio_stream
	sd_shoot.play()
