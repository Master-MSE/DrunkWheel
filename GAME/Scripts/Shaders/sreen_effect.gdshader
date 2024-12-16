shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform int index;
global uniform float tauxalcool;
global uniform vec2 screen_size;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	float time_s = (TIME*2.0);
	float delay_taux_vague=tauxalcool-1.0;
	float amp_vague=clamp(delay_taux_vague*0.004,0.0,0.02);
	float fre_vague=10.0;
	float vague = sin(SCREEN_UV.y*fre_vague+time_s+PI/2.0)*amp_vague;

	float delay_taux_diffraction=tauxalcool-4.0;
	float amp_diffraction=clamp(delay_taux_diffraction*0.015,0.0,0.08);
	float diffraction=amp_diffraction*sin(time_s/2.0);

	vec2 car_position = vec2(0.5,0.8);
	float delay_shado = clamp((tauxalcool-74.0/11.0)*11.0/6.0,-20.0,6.0);//t4->-5 tt10 ->6
	float attenuation_shado =  0.09;
	float fade_radius =delay_shado*attenuation_shado;
	float slope=3.0;

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
			vec2 aspect_ratio = vec2(screen_size.x/screen_size.y, 1.0);
			vec2 point_position = car_position * aspect_ratio ; //* vec2(SCREEN_PIXEL_SIZE.y, SCREEN_PIXEL_SIZE.x);
			vec2 current_position = SCREEN_UV * aspect_ratio; //* vec2(SCREEN_PIXEL_SIZE.y, SCREEN_PIXEL_SIZE.x);
			float distance_to_point = distance(current_position, point_position);
			float alpha = clamp(pow(distance_to_point+fade_radius,slope), 0.0, 0.99);
			COLOR = vec4(0,0,0,alpha);
			break;
		case 4:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,1);
			break;
		case 5:
			COLOR = vec4(SCREEN_UV.x-0.0,0,0,1);
			break;
		default:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,1);
			break;
	}

	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
