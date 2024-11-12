shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform int index;
global uniform float tauxalcool;

global uniform float phase_time;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time_s = (TIME*2.0*PI)+phase_time;
	float offset = tauxalcool*3.0;//*sin(time*PI);
	switch (index){
		case 1:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+sin(SCREEN_UV.y*15.0+time_s)*SCREEN_PIXEL_SIZE.x*tauxalcool*3.0+(offset*SCREEN_PIXEL_SIZE.x)*sin(time_s),SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.5);
			break;
		case 2:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+sin(SCREEN_UV.y*15.0+time_s)*SCREEN_PIXEL_SIZE.x*tauxalcool*3.0-(offset*SCREEN_PIXEL_SIZE.x)*sin(time_s),SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,0.5);
			break;
		default:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+sin(SCREEN_UV.y*15.0+time_s)*SCREEN_PIXEL_SIZE.x*tauxalcool*3.0,SCREEN_UV.y));
			COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,1);
			break;
	}

	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
