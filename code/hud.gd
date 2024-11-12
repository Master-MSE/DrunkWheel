extends CanvasLayer

func update_alcool(alcohol: int) -> void:
	var alcohol_label = "Alcohol collected = {alcohol}"
	$Alcool.text = alcohol_label.format({"alcohol": str(alcohol)})

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
