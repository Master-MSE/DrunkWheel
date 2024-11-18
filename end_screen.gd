extends Control

@onready var total_points_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Total_points
@onready var damage_costs_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Damage_costs
@onready var damage_costs_text_label = $Ticket/VBoxContainer2/HBoxContainer/Text_container/Damage_costs
@onready var final_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Final_score
@onready var best_score_label = $Ticket/VBoxContainer2/HBoxContainer/Score_container/Best_score

var best_score = 0
var signal_connected = false

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
	total_points_label.text = "%6d" % total_points

	# Prepare detailed damage costs
	var damage_costs_text = ""
	var damage_costs_value = ""
	
	for key in damage_breakdown.keys():
		var count = damage_breakdown[key]
		var cost_per_item = damage_values[key]
		var total_for_item = count * cost_per_item
		damage_costs_text += "- %s : %d x %d\n" % [key, count, cost_per_item]
		damage_costs_value += "%6d\n" % [total_for_item]

	damage_costs_text_label.text = damage_costs_text.strip_edges() 
	damage_costs_label.text = damage_costs_value.strip_edges() 
	
	final_score_label.text = "%6d" % final_score
	best_score_label.text = "%6d" % best_score

	# Update best score if necessary
	if final_score > best_score:
		best_score = final_score
	
	$Ticket._draw()
	self.visible = true
