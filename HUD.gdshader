shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
global uniform float tauxalcool;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 hsv_to_rgb(float h, float s, float v) {
    float c = v * s;
    float x = c * (1.0 - abs(mod(h * 6.0, 2.0) - 1.0));
    float m = v - c;

    vec3 rgb = vec3(0.0);
    if (h < 1.0 / 6.0)      rgb = vec3(c, x, 0.0);
    else if (h < 2.0 / 6.0) rgb = vec3(x, c, 0.0);
    else if (h < 3.0 / 6.0) rgb = vec3(0.0, c, x);
    else if (h < 4.0 / 6.0) rgb = vec3(0.0, x, c);
    else if (h < 5.0 / 6.0) rgb = vec3(x, 0.0, c);
    else                    rgb = vec3(c, 0.0, x);

    return rgb + m;
}

void fragment() {
	//vec4 tex_color = texture(, UV); // Couleur de base de la texture
    vec3 base_color = vec3(COLOR.r,COLOR.g,COLOR.b);
	float transition = clamp(tauxalcool,0.0,10.0)/10.0;

    float hue = mix(0.66, 0.0, transition);
	vec3 target_color = hsv_to_rgb(hue, 1.0, 1.0);
    // Appliquer la transition
    COLOR = vec4(target_color * base_color, COLOR.a);
	
}




//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
