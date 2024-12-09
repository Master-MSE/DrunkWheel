extends CanvasLayer

@onready var alcoolbar: ColorRect = $ColorRect
@onready var alcoolbar_bot: Sprite2D = $Sprite2D
@onready var alcoolbar_top: Sprite2D = $Sprite2D2


const base_screen_size = Vector2(1152,642)
var base_position_color=Vector2(1089,442.5)
var base_size_color=Vector2(18,0)

func update_alcohol(alcohol: int) -> void:
	var alcohol_label = "Alcohol collected = {alcohol}"
	$Alcool.text = alcohol_label.format({"alcohol": str(alcohol)})
	
func update_taux(taux: float) -> void:
	var alcohol_label = "Taux = {taux}"
	$Taux.text = alcohol_label.format({"taux": str(taux)})
	alcoolbar.update_alcol_bar(taux)
	
func updadte_affichage(new_screen_size:Vector2)->void:
	var scaling= new_screen_size/base_screen_size
	alcoolbar_bot.scale=scaling*0.3
	alcoolbar_top.scale=scaling*0.3
	alcoolbar.scale=scaling
	alcoolbar.position=base_position_color*scaling

func update_obects(objects: int) -> void:
	var objects_label = "Objects hit = {objects}"
	$Object.text = objects_label.format({"objects": str(objects)})
	
# Called when the node enters the scene tree for the first time.
