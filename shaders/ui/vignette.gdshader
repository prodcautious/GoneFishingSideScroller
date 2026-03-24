shader_type canvas_item;

uniform float inner_radius = 0.3;
uniform float outer_radius = 1.0;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    float len = length(UV - vec2(0.5));
    float vignette = smoothstep(inner_radius, outer_radius, len);
    COLOR = mix(vec4(0.0), vignette_color, vignette);
}
