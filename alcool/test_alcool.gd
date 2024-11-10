extends Node3D

var child
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			for i in range(child.mesh.get_surface_count()):
				var seed = randf()
				child.set_instance_shader_parameter("seed", seed)
				child.set_instance_shader_parameter("Scale", i)
				var material = child.mesh.surface_get_material(i)
				var over_mat = child.get_surface_override_material(i)
				var albedo_color = material.albedo_color;
				over_mat.set_shader_parameter("albedo_color_surface",albedo_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
