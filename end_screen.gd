extends CanvasLayer

@onready var total_points_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Total_points
@onready var damage_costs_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Damage_costs
@onready var damage_costs_text_label = $Ticket/VBoxContainer2/HBoxContainer/Text_container/Damage_costs
@onready var final_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Final_score
@onready var best_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Best_score
@onready var container_text = $VBoxContainer
@onready var container_score = $Ticket/VBoxContainer2
@onready var label_creator = $Creator
@onready var label_context = $Context


signal restart_game
static var best_score = -INF
const base_screen_size = Vector2(1152,642)
const base_position_label_creator= Vector2(691,608)
const base_position_label_context= Vector2(13,613)
const base_position_container_text= Vector2(290,0)
const base_position_container_score= Vector2(382.5,170)
var scaling=Vector2(1.0,1.0)
var damage_values = {
	"Light": -100, 
	"Light2": -100, 
	"Light3": -100, 
}

func _ready() -> void:
	_on_end_reached()

# Calcul total damages according to damage values
func calculate_total_damage() -> Dictionary:
	var total_damage = 0
	var damage_breakdown = {}  # Dictionary to store the breakdown
	
	for obj in Car.hitted_objects:
		if damage_values.has(obj):
			if not damage_breakdown.has(obj):
				damage_breakdown[obj] = 0
			damage_breakdown[obj] += 1
			total_damage += damage_values[obj]
		else:
			print("Unknown object type: %s" % obj)
	
	return {"total_damage": total_damage, "damage_breakdown": damage_breakdown}
	
# Print the results
func _on_end_reached():
	var results = calculate_total_damage()
	var damage_costs = results["total_damage"]
	var damage_breakdown = results["damage_breakdown"]

	var total_points = Game.alcohol_collected * 100
	var final_score = total_points + damage_costs
	total_points_label.text = " %d" % total_points

	# Prepare detailed damage costs
	var damage_costs_text = ""
	var damage_costs_value = ""
	
	for key in damage_breakdown.keys():
		var count = damage_breakdown[key]
		var cost_per_item = damage_values[key]
		var total_for_item = count * cost_per_item
		damage_costs_text += "- %s : %d x %d\n" % [key, count, cost_per_item]
		damage_costs_value += "%d\n" % total_for_item

	damage_costs_text_label.text = damage_costs_text.strip_edges() 
	damage_costs_label.text = damage_costs_value.strip_edges() 
	
	final_score_label.text = "%d" % final_score
	
	# Update best score if necessary
	if final_score > best_score:
		best_score = final_score
	
	best_score_label.text = "%d" % best_score
	
	$Ticket.scal_draw(scaling)
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
	label_context.position=base_position_label_context*scaling
	label_creator.position=base_position_label_creator*scaling
	container_text.position=base_position_container_text*scaling
	$Ticket.position=base_position_container_score*scaling
	$Ticket.scal_draw(scaling)
