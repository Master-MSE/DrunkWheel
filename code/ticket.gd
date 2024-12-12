extends Control


@onready var titre = $VBoxContainer2/Header
@onready var container = $VBoxContainer2
@onready var container_text = $VBoxContainer2/HBoxContainer/Text_container
var scaling=Vector2(1.0,1.0)

func _ready() -> void:
	pass
	
func scal_draw(scal)-> void:
	scaling=scal
	self.queue_redraw()
func _draw() -> void:
	var padding = 20
	var size_y=container_text.get_minimum_size().y+titre.get_minimum_size().y

	# Add padding to the rectangle bounds
	var rect_position = Vector2(container.position.x - padding, container.position.y - padding)
	var rect_size = Vector2(container.size.x + padding * 2, size_y + padding * 2)*scaling

	# Draw the background rectangle
	draw_rect(Rect2(rect_position, rect_size), Color(0.9, 0.9, 0.9, 1))  # Light gray background
	draw_rect(Rect2(rect_position, rect_size), Color(0, 0, 0, 1), false)  # Black border
