extends Node3D

@onready var sprite1: Sprite3D = $Sprite3D
@onready var sprite2: Sprite3D = $Sprite3D2
@onready var sprite3: Sprite3D = $Sprite3D3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var r_sprit=randi()%3
	if r_sprit == 0:
		sprite1.visible=true
		sprite2.visible=false
		sprite3.visible=false
	elif r_sprit == 1:
		sprite1.visible=false
		sprite2.visible=true
		sprite3.visible=false
	else :
		sprite1.visible=false
		sprite2.visible=false
		sprite3.visible=true	
	$AnimationPlayer_drink.play("drink")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_drink_animation_finished(anim_name: StringName) -> void:
	queue_free()
