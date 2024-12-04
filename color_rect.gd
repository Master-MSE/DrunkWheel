extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Passe la taille de l'écran au démarrage
	update_shader_screen_size()
	# Connecte un signal pour détecter les changements de taille
	get_tree().connect("screen_resized",Callable(self, "_on_screen_resized"))

func _on_screen_resized():
	# Met à jour la taille de l'écran lorsque la fenêtre est redimensionnée
	update_shader_screen_size()
	
func update_shader_screen_size():
	# Récupère la taille de l'écran et la passe au shader
	var shader = material
	if shader:
		var screen_size = get_viewport().get_size()
		shader.set_shader_param("screen_size", screen_size)
	
