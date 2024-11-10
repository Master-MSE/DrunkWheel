shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform int index;
global uniform float tauxalcool;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//float time = TIME;
	//float offset = sin(time)*tauxalcool*3.0;
	float offset = 20.0;
	switch (index){
		default:
			vec4 first_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+sin(SCREEN_UV.y*2.0*PI+TIME)*SCREEN_PIXEL_SIZE.x*10.0,SCREEN_UV.y));
			//COLOR = vec4(first_chanel.r,first_chanel.g,first_chanel.b,1);
			break;
	}
	vec4 r_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x,SCREEN_UV.y));
	vec4 g_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+(offset*SCREEN_PIXEL_SIZE.x),SCREEN_UV.y));
	vec4 b_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x-(offset*SCREEN_PIXEL_SIZE.x),SCREEN_UV.y));
	COLOR= vec4(0,0,0,1);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
