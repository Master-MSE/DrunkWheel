extends Node3D

@onready var sprite1: Sprite3D = $Sprite3D
@onready var sprite2: Sprite3D = $Sprite3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var r_sprit=randi()%2
	if r_sprit == 0:
		sprite1.visible=true
		sprite2.visible=false
	else:
		sprite1.visible=false
		sprite2.visible=true
		
	$AnimationPlayer_drink.play("crash")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_drink_animation_finished(anim_name: StringName) -> void:
	queue_free()
