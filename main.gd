extends Node


# Déclare la scène de plateforme que l'on va instancier
@export var platform_scene:PackedScene

@export var alcohol_scene:PackedScene

# Distance horizontale entre les plateformes
@export var platform_spacing := Vector3(0, 0,80)

# Stocke la dernière plateforme créée pour positionner la suivante
var last_platform_position := Vector3(0, 0, -80)

# Score du joueur
var score := 0
var score_label: Label
var player

func _ready():
	# Crée la première plateforme au démarrage du jeu
	_add_new_platform()
	score_label = $CanvasLayer/Label
	 # Récupère la référence au joueur
	player = $Player  # Assurez-vous que le chemin correspond à votre joueur
	# Connecte le signal 'alcohol_collected' du joueur à une méthode du script Main
	if player:
		player.connect("alcohol_collected", Callable(self, "_on_alcohol_body_entered"))
	
	_update_score_display()

# Fonction appelée pour ajouter une nouvelle plateforme
func _add_new_platform():
	# Instancie une nouvelle plateforme à partir de la scène
	print("Plateforme")
	var new_platform = platform_scene.instantiate()
	
	# Positionne la nouvelle plateforme juste après la dernière
	new_platform.position = last_platform_position + platform_spacing
	# Ajoute la plateforme à la scène
	add_child(new_platform)
	
	# Met à jour la position de la dernière plateforme
	last_platform_position = new_platform.position
	
	# Connecte le signal "body_entered" du Area3D de la nouvelle plateforme
	# Vérifie si le nœud 'trap_gen' existe sous 'Ground'
	if new_platform.has_node("trap_gen"):
		new_platform.get_node("trap_gen").connect("body_entered", Callable(self, "_on_platform_zone_entered"))
	else:
		print("Error: 'trap_gen' node not found under 'Ground'!")
		
	 # Ajoute entre 1 et 3 objets "Alcool" sur la plateforme
	var number_of_alcohol = randi() % 3 + 1  # Choisit un nombre aléatoire entre 1 et 3
	for i in range(number_of_alcohol):
		_add_alcohol_to_platform(new_platform)
		
func _add_alcohol_to_platform(platform):
	# Instancie un objet "Alcool"
	var alcohol_instance = alcohol_scene.instantiate()
	
	
	# Positionne l'objet "Alcool" à une position aléatoire sur la plateforme
	alcohol_instance.position.x = randf_range(-1.0, 1.0) * 10   
	alcohol_instance.position.y = 0  # Ajuste la hauteur
	alcohol_instance.position.z = randf_range(-1.0, 1.0) * 40   
	
	# Ajoute l'objet à la plateforme
	platform.add_child(alcohol_instance)
	
func _update_score_display():
	score_label.text = "Score: " + str(score)
	
# Fonction appelée lorsqu'un corps entre dans la zone de la plateforme
func _on_platform_zone_entered(body):
	
	if body.name == "Player":  # Vérifie si c'est le joueur qui entre dans la zone
		_add_new_platform()  # Ajoute une nouvelle plateforme
		
func _on_alcohol_body_entered():
		score += 1  # Augmente le score
		_update_score_display()  # Met à jour l'affichage du score
		print("Le joueur a collecté de l'alcool. Score actuel: " + str(score))
