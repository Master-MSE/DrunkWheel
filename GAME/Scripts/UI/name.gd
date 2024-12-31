extends LineEdit
const MAX_CHARACTER = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_changed(new_text:String) -> void:
	var length=new_text.length()
	if  length > MAX_CHARACTER:
		text = new_text.substr(0, MAX_CHARACTER)	
		caret_column =length
