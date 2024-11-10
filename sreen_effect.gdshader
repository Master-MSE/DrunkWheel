shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
global uniform float tauxalcool;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time = TIME;
	float offset = sin(time)*tauxalcool*3.0;
	vec4 green_chanel = texture(SCREEN_TEXTURE,SCREEN_UV);
	vec4 red_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x+(offset*SCREEN_PIXEL_SIZE.x),SCREEN_UV.y));
	vec4 blue_chanel = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x-(offset*SCREEN_PIXEL_SIZE.x),SCREEN_UV.y));
	COLOR = vec4(green_chanel.r,red_chanel.g,blue_chanel.b,1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
