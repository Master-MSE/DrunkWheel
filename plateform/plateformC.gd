extends StaticBody3D
signal generation(case: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_trap_gen_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Vérifie si c'est le joueur qui entre dans la zone
		emit_signal("generation",1)
		# Désactive l'Area3D
		var area = self.get_node("trap_gen")
		if area:
			area.queue_free()
			print("Area disabled!")
