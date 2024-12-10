shader_type canvas_item;


uniform bool end;
uniform float time;
uniform float starttime;
uniform float endtime;


const float particle_count = 80.0;
const float size = 2.0;
const float sharpen = 1.7;
const float speed = 0.5;
const float gravity = 35.0;
const float lifetime = 1.0; 
const float angle = 10.0; 
const float horizontal_offset_range = 0.02; 

vec2 noise(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)), dot(uv, vec2(269.5, 183.3)));
    return fract(sin(uv) * 43758.5453123) * 0.5;
}
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}
vec3 spark(vec2 uv, vec2 position, float index, float cycle, float fade) {
	float  f_angle= random(vec2(index* 0.543123,0.1)) * angle* 2.0 -angle ;
    float angle_radians = radians(f_angle+90.0);
    
	
    float speed_factor = 2.0 + (cycle / lifetime); // Vitesse variable en fonction du cycle
    float direction_x = cos(angle_radians) * speed_factor; 
    float direction_y = sin(angle_radians) * speed_factor; 
    
    vec2 direction = vec2(direction_x, direction_y);
    
    
    direction.y -= cycle * gravity * 0.1;


    float alpha = 1.0 - (cycle / lifetime);

    // Calcule l'intensité de chaque particule
    float shape = 1.0 / length(uv + position + direction * cycle) * size * 0.01;
    float red = shape * noise(vec2(0.1, 0.2) * index).x;
    float green = shape * noise(vec2(0.3, 0.4) * index).x;
    float blue = shape * noise(vec2(0.5, 0.6) * index).x;
    
    return pow(vec3(red, green, blue), vec3(sharpen)) * fade * alpha;
}

vec3 firework(vec2 uv) {
	vec3 color = vec3(0.0);
    for (float i = 1.0; i <= particle_count; i += 1.0) {
		float cycle = mod(time * speed+ (i / particle_count)*lifetime , lifetime);
		if(((time-starttime)* speed>cycle&&!end)||(cycle>(time-endtime)*speed)){
		
				if (cycle >= 0.0 && cycle <= lifetime) {
		 			float fade = smoothstep(0.0, 0.2, lifetime - cycle);
					float horizontal_offset = random(vec2(i / particle_count,0.1)) * horizontal_offset_range * 2.0 - horizontal_offset_range;
		    		vec2 position = vec2(horizontal_offset-0.5, -0.45);
		        	color += spark(uv, position, i, cycle, fade);
				}
			
		}
    }
    return color;
}

void fragment() {
    vec3 color = vec3(0.0);
    color += firework(UV);
    float alpha = clamp(length(color), 0.0, 1.0);
    COLOR = vec4(color, alpha);
}
