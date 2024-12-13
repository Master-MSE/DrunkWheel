extends MeshInstance3D

var base_scale_x = 8.0
var amplitude_x = 4.0

var base_scale_z = 32.0
var amplitude_z = 16.0

var scale_speed = 0.07 
var time = 0.0 

# Called every time the Timer times out
func _on_timer_timeout():
	time += 0.1

	var scale_factor_x = base_scale_x + abs(sin(time) * amplitude_x)
	var scale_factor_z = base_scale_z + abs(sin(time) * amplitude_z)

	self.scale = Vector3(scale_factor_x, 4.0, scale_factor_z)
