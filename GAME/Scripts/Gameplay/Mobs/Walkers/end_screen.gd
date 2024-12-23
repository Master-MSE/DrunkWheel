extends CanvasLayer

@onready var total_points_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Total_points
@onready var damage_costs_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Damage_costs
@onready var damage_costs_text_label = $Ticket/VBoxContainer2/HBoxContainer/Text_container/Damage_costs
@onready var final_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Final_score
@onready var best_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Best_score
@onready var container_score = $Ticket/VBoxContainer2
@onready var ticket = $Ticket
@onready var label_creator = $Creator
@onready var label_context = $Context
@onready var container_text = $VBoxContainer
@onready var name_score = $Ticket/VBoxContainer2/VBoxContainer3/Name
@onready var textureRec = $TextureRect
@onready var scores_name = $Scores_name
@onready var scores_value = $Scores_value

	


signal restart_game
static var best_score = -INF
const base_screen_size = Vector2(1152,642)
const base_position_label_creator= Vector2(691,608)
const base_position_label_context= Vector2(13,613)
const base_position_container_text= Vector2(290,0)
const base_position_container_score= Vector2(382,170)
const base_position_scores_name= Vector2(850,150)
const base_position_scores_value= Vector2(990,150)

var scaling=Vector2(1.0,1.0)
var final_score


func _ready() -> void:
	update_background()
	_on_end_reached()
	var screen_size = get_viewport().get_size()
	updadte_affichage(screen_size)


# Print the results
func _on_end_reached():
	var damage_costs = -CollisionHandler.get_collision_prices_total()
	var damages_values =CollisionHandler.get_collision_prices()
	var damage_breakdown =CollisionHandler.get_registered_collisions()
	
	var total_points = AlcoolScore.get_score()
	final_score = total_points + damage_costs
	total_points_label.text = " %d" % total_points

	# Prepare detailed damage costs
	var damage_costs_text = ""
	var damage_costs_value = ""
	
	for key in damage_breakdown.keys():
		var count = damage_breakdown[key]
		var cost_per_item = damages_values[key]
		var total_for_item = count*cost_per_item
		damage_costs_text += "- %s : %d x %d\n" % [key, count, cost_per_item]
		damage_costs_value += "%d\n" % total_for_item

	damage_costs_text_label.text = damage_costs_text.strip_edges() 
	damage_costs_label.text = damage_costs_value.strip_edges() 
	
	final_score_label.text = "%d" % final_score
	
	# Update best score if necessary
	if final_score > best_score:
		best_score = final_score
	
	best_score_label.text = "%d" % best_score
	update_scores()
	ticket.scal_draw(scaling)
	self.visible = true

func _on_start_pressed() -> void:
	restart_game.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func updadte_affichage(new_screen_size:Vector2)->void:
	scaling= new_screen_size/base_screen_size
	label_context.scale=scaling
	label_creator.scale=scaling
	container_text.scale=scaling
	container_score.scale=scaling
	scores_name.scale=scaling
	scores_value.scale=scaling
	label_context.position=base_position_label_context*scaling
	label_creator.position=base_position_label_creator*scaling
	container_text.position=base_position_container_text*scaling
	ticket.position=base_position_container_score*scaling
	scores_name.position=base_position_scores_name*scaling
	scores_value.position=base_position_scores_value*scaling
	ticket.scal_draw(scaling)
	
	
	
func update_background()->void:
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	textureRec.texture=tex


func _on_sign_pressed() -> void:
	$Ticket/VBoxContainer2/VBoxContainer2/Quit.visible=true
	$Ticket/VBoxContainer2/VBoxContainer2/Start.visible=true
	$Ticket/VBoxContainer2/VBoxContainer2/Quit.disabled=false
	$Ticket/VBoxContainer2/VBoxContainer2/Start.disabled=false
	$Ticket/VBoxContainer2/VBoxContainer3/Name.visible=false
	$Ticket/VBoxContainer2/VBoxContainer3/Sign.visible=false
	var name_score=name_score.text
	SaveScore.add_score(name_score,final_score)
	SaveScore.save_score()
	update_scores()
	
func update_scores()-> void:
	var scores_sort=SaveScore.get_score()
	var scores_text = ""
	var scores_values = ""
	for score in scores_sort:
		var name=score["name"]
		var value=score["score"]
		scores_text += "%s\n" % name
		scores_values += ": %s\n" % value
	scores_name.text = scores_text
	scores_value.text = scores_values
