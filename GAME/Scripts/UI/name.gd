extends TextEdit
const MAX_CHARACTER = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_changed() -> void:
	if text.length() > MAX_CHARACTER:
		text = text.substr(0, MAX_CHARACTER)	
