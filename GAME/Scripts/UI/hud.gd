extends CanvasLayer

@onready var alcoolbar: ColorRect = $ColorRect
@onready var particles: ColorRect = $Particule
@onready var alcoolbar_bot: Sprite2D = $Sprite2D
@onready var alcoolbar_top: Sprite2D = $Sprite2D2


const base_screen_size = Vector2(1152,642)
var base_position_color=Vector2(1089,442.5)
var base_position_particles=Vector2(1030,39)
var base_size_color=Vector2(18,0)
var actuly_state=false

func update_alcohol(alcohol: int) -> void:
	var alcohol_label = "Alcohol collected = {alcohol}"
	$Alcool.text = alcohol_label.format({"alcohol": str(alcohol)})
	
	
func update_taux(taux: float) -> void:
	var alcohol_label = "Taux = {taux}"
	$Taux.text = alcohol_label.format({"taux": str(taux)})
	alcoolbar.update_alcol_bar(taux)
	if taux >10:
		set_change_particles(true)
	else:
		set_change_particles(false)
	
func updadte_affichage(new_screen_size:Vector2)->void:
	var scaling= new_screen_size/base_screen_size
	alcoolbar_bot.scale=scaling*0.3
	alcoolbar_top.scale=scaling*0.3
	alcoolbar.scale=scaling
	particles.scale=scaling
	alcoolbar.position=base_position_color*scaling
	particles.position=base_position_particles*scaling
	
	
func set_change_particles(state:bool)->void:
	if state!=actuly_state:
		actuly_state=state
		particles.set_particles(state)
	
