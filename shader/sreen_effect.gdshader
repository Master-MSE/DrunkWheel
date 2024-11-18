shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform int index;
global uniform float tauxalcool;
global uniform float time;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
		
	float time_s = (time*2.0*PI);
	float amp_vague=tauxalcool*3.0;
	float fre_vague=15.0;
	float vague = sin(SCREEN_UV.y*fre_vague+time_s)*SCREEN_PIXEL_SIZE.x*amp_vague;
	float amp_diffraction=tauxalcool*10.0;
	float diffraction=amp_diffraction*SCREEN_PIXEL_SIZE.x*sin(time_s);
	switch (index){
		case 1:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague+diffraction,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.5);
			break;
		case 2:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+vague-diffraction,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.5);
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
