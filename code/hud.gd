extends CanvasLayer

func update_alcohol(alcohol: int) -> void:
	var alcohol_label = "Alcohol collected = {alcohol}"
	$Alcool.text = alcohol_label.format({"alcohol": str(alcohol)})
	
func update_taux(taux: float) -> void:
	var alcohol_label = "Taux = {taux}"
	$Taux.text = alcohol_label.format({"taux": str(taux)})

func update_obects(objects: int) -> void:
	var objects_label = "Objects hit = {objects}"
	$Object.text = objects_label.format({"objects": str(objects)})
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
