extends CanvasLayer

@onready var alcoolbar: ColorRect = $ColorRect
@onready var particles: ColorRect = $Particule
@onready var alcoolbar_bot: Sprite2D = $Sprite2D
@onready var alcoolbar_top: Sprite2D = $Sprite2D2
@onready var alcoolbar_txt: Label = $txt_alcool


const base_screen_size = Vector2(1152,642)
var base_position_color=Vector2(1089,442.5)
var base_position_particles=Vector2(1030,39)
var base_position_txt=Vector2(1007,490)
var base_size_color=Vector2(18,0)
var actuly_state=false

	
func update_taux(taux: float) -> void:
	var alcohol_label = "Taux = {taux}"
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
	alcoolbar_txt.scale=scaling
	alcoolbar.position=base_position_color*scaling
	particles.position=base_position_particles*scaling
	alcoolbar_txt.position=base_position_txt*scaling
	
func set_change_particles(state:bool)->void:
	if state!=actuly_state:
		actuly_state=state
		particles.set_particles(state)
func reset()->void:
	particles.reset()
	
