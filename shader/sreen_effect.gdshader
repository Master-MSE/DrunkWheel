shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform int index;
global uniform float tauxalcool;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time_s = (TIME*2.0);
	float delay_taux_vague=max(tauxalcool-0.0,0.0);
	float amp_vague=delay_taux_vague*15.0;
	float fre_vague=10.0;
	float vague = sin(SCREEN_UV.y*fre_vague+time_s+PI/2.0)*SCREEN_PIXEL_SIZE.x*amp_vague;
	
	float delay_taux_diffraction=max(tauxalcool-0.0,0.0);
	float amp_diffraction=delay_taux_diffraction*30.0;
	float diffraction=amp_diffraction*SCREEN_PIXEL_SIZE.x*sin(time_s/2.0);
	
	vec2 car_position = vec2(0.5,0.8);
	float fade_radius =tauxalcool*0.5;
	float attenuation_shado =  2000.0;
	float delay_shado = 3.0;//delay_shado is linked to attenuation_shado 
	
	switch (index){
		case 1:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague+diffraction,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.3);
			break;
		case 2:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague-diffraction,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.3);
			break;
		case 3:
			vec2 point_position = car_position * vec2(SCREEN_PIXEL_SIZE.y, SCREEN_PIXEL_SIZE.x);
			vec2 current_position = SCREEN_UV * vec2(SCREEN_PIXEL_SIZE.y, SCREEN_PIXEL_SIZE.x);
			float distance_to_point = distance(current_position, point_position);
			float alpha = 1.0-clamp(delay_shado-fade_radius-distance_to_point*attenuation_shado, 0.0, 1.0);
			COLOR = vec4(0,0,0,alpha);
			break;
		default:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,1);
			break;
	}

	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
