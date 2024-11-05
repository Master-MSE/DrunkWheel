extends StaticBody3D

var child

func self_delet():
	self.queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			for newchild in child.get_children():
				if newchild is MeshInstance3D:
					var seed = randf()
					newchild.set_instance_shader_parameter("seed", seed)
					print("Hello")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
