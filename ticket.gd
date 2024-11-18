extends Control

@onready var total_points_label = $VBoxContainer2/HBoxContainer/Score_container/Total_points
@onready var damage_costs_label = $VBoxContainer2/HBoxContainer/Score_container/Damage_costs
@onready var damage_label = $VBoxContainer2/HBoxContainer/Score_container/Damage
@onready var final_score_label = $VBoxContainer2/HBoxContainer/Score_container/Final_score
@onready var best_score_label = $VBoxContainer2/HBoxContainer/Score_container/Best_score
@onready var line_label = $VBoxContainer2/HBoxContainer/Score_container/Line

func _ready() -> void:
	pass

func _draw() -> void:
	var padding = 20

	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	var size_y = 0
	
	# Get the positions and sizes of each label
	var labels = [line_label, line_label, line_label, total_points_label, damage_label, damage_costs_label, final_score_label, best_score_label]
	for label in labels:
		var label_pos = label.global_position - global_position
		var label_size = label.get_minimum_size()
		
		min_x = min(min_x, label_pos.x)
		max_x = max(max_x, label_pos.x + label_size.x)
		min_y = min(min_y, label_pos.y)
		max_y = max(max_y, label_pos.y + label_size.y)
		size_y += (max_y - min_y)

	# Add padding to the rectangle bounds
	var rect_position = Vector2(min_x - padding, min_y - padding)
	var rect_size = Vector2((max_x - min_x) * 3.3 + padding * 2, size_y + padding * 2)

	# Draw the background rectangle
	draw_rect(Rect2(rect_position, rect_size), Color(0.9, 0.9, 0.9, 1))  # Light gray background
	draw_rect(Rect2(rect_position, rect_size), Color(0, 0, 0, 1), false)  # Black border
