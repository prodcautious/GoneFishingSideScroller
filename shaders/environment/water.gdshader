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

uniform float reflection_strength : hint_range(0.0, 1.0) = 0.45;
uniform float reflection_fade : hint_range(0.0, 4.0) = 1.25;
uniform float reflection_stretch : hint_range(0.1, 2.0) = 1.0;

// Keep this at 0 if you want a completely stable reflected image.
uniform float distortion_pixels : hint_range(0.0, 16.0) = 0.0;

// New: manually offset the reflection surface if needed.
uniform float reflection_surface_offset_pixels : hint_range(-64.0, 64.0) = 0.0;

varying float vertex_wave_offset;

void vertex() {
	float top = 1.0 - UV.y;

	float wave = sin(VERTEX.x * 0.08 + TIME * edge_wave_speed) * 0.5
			   + sin(VERTEX.x * 0.13 + TIME * edge_wave_speed * 0.7) * 0.5;

	vertex_wave_offset = wave * edge_wave_height * top;

	VERTEX.y -= vertex_wave_offset;
}

void fragment() {
	float uv_to_screen_y = dFdy(SCREEN_UV.y) / max(dFdy(UV.y), 0.00001);

	// This is the animated/wavy top edge from the current mesh.
	float animated_water_top_screen_y = SCREEN_UV.y - UV.y * uv_to_screen_y;

	// Convert the vertex wave offset from pixels into screen UV.
	float vertex_wave_screen_offset = vertex_wave_offset * SCREEN_PIXEL_SIZE.y;

	// Undo the visual vertex wave for the reflection anchor.
	// This gives us a stable/original water surface line.
	float stable_water_top_screen_y = animated_water_top_screen_y + vertex_wave_screen_offset;

	stable_water_top_screen_y += reflection_surface_offset_pixels * SCREEN_PIXEL_SIZE.y;

	float distance_below_surface = UV.y * uv_to_screen_y * reflection_stretch;

	vec2 reflection_uv = SCREEN_UV;
	reflection_uv.y = stable_water_top_screen_y - distance_below_surface;

	// Optional tiny distortion. Keep distortion_pixels at 0 for no reflection swimming.
	if (distortion_pixels > 0.0) {
		vec2 noise_uv = UV + vec2(TIME * 0.02, TIME * 0.015);
		vec2 noise = texture(wave_noise, noise_uv).rg - 0.5;
		vec2 distortion = noise * distortion_pixels * SCREEN_PIXEL_SIZE;
		reflection_uv += distortion;
	}

	reflection_uv = clamp(reflection_uv, vec2(0.001), vec2(0.999));

	vec4 reflected_color = texture(screen_texture, reflection_uv);

	float depth_fade = pow(1.0 - UV.y, reflection_fade);

	float brightness = dot(reflected_color.rgb, vec3(0.333));
	brightness = pow(brightness, 1.4);

	float reflection_amount = reflection_strength * depth_fade;
	reflection_amount += brightness * 0.25 * depth_fade;
	reflection_amount = clamp(reflection_amount, 0.0, 0.7);

	vec4 base = mix(water_color, reflected_color, reflection_amount);

	float noise_sample = texture(wave_noise, UV * foam_noise_scale + TIME * 0.05).r;
	float foam_edge = foam_thickness + (noise_sample - 0.5) * foam_noise_strength * foam_thickness;

	float foam_amount = 1.0 - smoothstep(0.0, foam_softness, UV.y - foam_edge);
	foam_amount = clamp(foam_amount, 0.0, 1.0);

	COLOR = mix(base, foam_color, foam_amount * foam_color.a);
}