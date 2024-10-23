extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_trap_gen_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Vérifie si c'est le joueur qui entre dans la zone
		# Désactive l'Area3D
		if self.has_node("MeshInstance3D"):  # Assurez-vous d'avoir le bon type
			var mesh_instance = self.get_node("MeshInstance3D")
			if mesh_instance.material_override:  # Vérifie si le matériel est assigné
				mesh_instance.material_override.albedo_color = Color(1, 0, 0)  # Change la couleur
		var area = self.get_node("trap_gen")
		if area:
			area.queue_free()
			print("Area disabled!")
