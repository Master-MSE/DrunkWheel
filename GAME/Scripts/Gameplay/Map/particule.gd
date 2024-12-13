extends ColorRect

var emit_particles = false
var time
func _ready() -> void:
	time=0
func set_particles(value:bool):
	emit_particles = value
	if !emit_particles:
		material.set_shader_parameter("endtime", time)
	else:
		material.set_shader_parameter("starttime", time)
	material.set_shader_parameter("end", !emit_particles)
	
func _process(delta: float) -> void:
	time+=delta
	material.set_shader_parameter("time", time)
		
	
	
