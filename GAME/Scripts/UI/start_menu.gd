extends Control

@onready var button_container = $VBoxContainer
@onready var label_title = $Title
@onready var label_creator = $Creator
@onready var label_context = $Context
@onready var label_text = $Label
@onready var scores_name = $Scores_name
@onready var scores_value = $Scores_value
@onready var scores_title = $Scores_title


signal start

const base_screen_size = Vector2(1152,642)
const base_position_container = Vector2(414.5,292.5)
const base_position_label_title = Vector2(290.5,20)
const base_position_label_creator= Vector2(691,608)
const base_position_label_context= Vector2(13,613)
const base_position_label_text= Vector2(202,184)
const base_position_scores_name= Vector2(850,170)
const base_position_scores_value= Vector2(990,170)
const base_position_scores_title= Vector2(850,118)

func _on_start_pressed() -> void:
	self.visible = false
	Game.game_state = Game.GameStates.PLAYING
	start.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _ready() -> void:
	update_scores()
	
func update_scores()-> void:
	var scores_sort=SaveScore.get_score()
	var scores_text = ""
	var scores_values = ""
	for score in scores_sort:
		var name=score["name"]
		var value=score["score"]
		scores_text += "%s :\n" % name
		scores_values += ": %d\n" % value
	scores_name.text = scores_text
	scores_value.text = scores_values
	
func updadte_affichage(new_screen_size:Vector2)->void:
	var scaling= new_screen_size/base_screen_size
	button_container.scale=scaling
	label_text.scale=scaling
	label_context.scale=scaling
	label_creator.scale=scaling
	label_title.scale=scaling
	scores_name.scale=scaling
	scores_value.scale=scaling
	scores_title.scale=scaling
	button_container.position=base_position_container*scaling
	label_text.position=base_position_label_text*scaling
	label_context.position=base_position_label_context*scaling
	label_creator.position=base_position_label_creator*scaling
	label_title.position=base_position_label_title*scaling
	scores_name.position=base_position_scores_name*scaling
	scores_value.position=base_position_scores_value*scaling
	scores_title.position=base_position_scores_title*scaling
