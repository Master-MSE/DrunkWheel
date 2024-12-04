extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func update_alcol_bar(tauxalcool)->void:
	var transition = clamp(tauxalcool,0.0,10.0)/10.0
	var hue = lerp(0.66, 0.0, transition)
	var leng = lerp(0, 306, transition)
	self.size.y=leng
	var target_color = hsv_to_rgb(hue,1.0,1.0)
	self.color=target_color
	
func hsv_to_rgb(h: float, s: float, v: float) -> Color:
	var c = v * s
	var x = c * (1.0 - abs(fmod((h * 6.0),2.0) - 1.0))
	var m = v - c
	
	var r=0.0
	var g=0.0
	var b=0.0

	if h < 1.0 / 6.0:
		r=c
		g=x
		b=0.0
	elif h < 2.0 / 6.0:
		r=x
		g=c
		b=0.0
	elif h < 3.0 / 6.0:
		r=0.0
		g=c
		b=x
	elif h < 4.0 / 6.0:
		r=0.0
		g=x
		b=c
	elif h < 5.0 / 6.0:
		r=x
		g=0.0
		b=c
	else:
		r=c
		g=0.0
		b=x
	return Color(r + m, g + m, b + m)

	
