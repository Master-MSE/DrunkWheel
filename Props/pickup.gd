extends StaticBody3D

@onready var beer_bottle : Node3D = $beer_bottle
@onready var beer_glass : Node3D = $beer_glass
@onready var shot_glass : Node3D = $shot_glass
@onready var wine_glass : Node3D = $wine_glass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi()%10 < 2:
		queue_free()
	else:
		var choix=randi()%4
		if choix==0:
			beer_glass.queue_free()
			shot_glass.queue_free()
			wine_glass.queue_free()
		elif choix==1:
			beer_bottle.queue_free()
			shot_glass.queue_free()
			wine_glass.queue_free()
		elif choix==2:
			beer_bottle.queue_free()
			beer_glass.queue_free()
			wine_glass.queue_free()
		else :
			beer_bottle.queue_free()
			beer_glass.queue_free()
			shot_glass.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.game_state != Game.GameStates.PLAYING:
		return
	
	rotate_y(0.1)
