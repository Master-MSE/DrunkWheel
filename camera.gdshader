shader_type canvas_item;

uniform float darkness_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D SCREEN_TEXTURE;
void fragment() {
    // Centre de l'écran en coordonnées UV
    vec2 center = vec2(0.5, 0.5);

    // Calcul de la distance du fragment au centre
    float dist = distance(UV, center);

    // Calcul de l'assombrissement basé sur la distance et les paramètres
    float vignette = smoothstep(radius, radius - 0.1, dist);
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Appliquer l'assombrissement selon l'intensité spécifiée
    COLOR = mix(color, color * vec4(vec3(1.0 - darkness_intensity), 1.0), vignette);
}
