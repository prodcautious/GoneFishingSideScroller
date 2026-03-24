shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture;
uniform vec4 water_color : source_color;
uniform sampler2D wave_noise : repeat_enable;
uniform float edge_wave_height : hint_range(0.0, 20.0) = 6.0;
uniform float edge_wave_speed : hint_range(0.0, 10.0) = 2.0;
uniform vec4 foam_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float foam_thickness : hint_range(0.0, 0.3) = 0.06;
uniform float foam_softness : hint_range(0.001, 0.1) = 0.03;
uniform float foam_noise_scale : hint_range(0.5, 10.0) = 3.0;
uniform float foam_noise_strength : hint_range(0.0, 1.0) = 0.5;

void vertex() {
    float top = 1.0 - UV.y;
    float wave = sin(VERTEX.x * 0.08 + TIME * edge_wave_speed) * 0.5
               + sin(VERTEX.x * 0.13 + TIME * edge_wave_speed * 0.7) * 0.5;
    VERTEX.y -= wave * edge_wave_height * top;
}

void fragment() {
    vec2 water_wave = (texture(wave_noise, UV + TIME * 0.02).rg - 0.5) * 0.02;
    vec2 uv = vec2(SCREEN_UV.x, SCREEN_UV.y - UV.y) + water_wave;
    vec4 color = texture(screen_texture, uv);
    float mix_value = (1.0 - UV.y) * 0.3;
    float avg_color = (color.r + color.g + color.b) / 3.0;
    mix_value = clamp(mix_value, 0.0, 0.7);
    avg_color = pow(avg_color, 1.4);
    mix_value += avg_color;
    vec4 base = mix(water_color, color, mix_value);

    // Foam band near the top edge (UV.y close to 0)
    float noise_sample = texture(wave_noise, UV * foam_noise_scale + TIME * 0.05).r;
    float foam_edge = foam_thickness + (noise_sample - 0.5) * foam_noise_strength * foam_thickness;
    float foam_amount = 1.0 - smoothstep(0.0, foam_softness, UV.y - foam_edge);
    foam_amount = clamp(foam_amount, 0.0, 1.0);

    COLOR = mix(base, foam_color, foam_amount * foam_color.a);
}