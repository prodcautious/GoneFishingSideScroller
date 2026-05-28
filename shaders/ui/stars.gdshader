shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.05, 0.05, 0.1, 1.0);
uniform vec4 star_color_1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 star_color_2 : source_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform float star_density : hint_range(0.0, 1.0) = 0.02;
uniform float flicker_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pixel_size : hint_range(1.0, 16.0) = 2.0;

// Better hash — avoids the fract(x*y) periodicity that causes visible patterns
float hash(vec2 p) {
	p = fract(p * vec2(0.1031, 0.1030));
	p += dot(p, p.yx + 33.33);
	return fract((p.x + p.y) * p.x);
}

void fragment() {
	// Convert UV → raw pixel coordinate, then bucket into cells.
	// Dividing by TEXTURE_PIXEL_SIZE gives pixel coords regardless of resolution,
	// so the star grid is stable across 480x270, 640x360, 960x540, 1920x1080.
	vec2 pixel_coord = floor(UV / TEXTURE_PIXEL_SIZE);
	vec2 grid = floor(pixel_coord / pixel_size);

	float rand  = hash(grid);
	float rand2 = hash(grid + vec2(7.3,  2.1));
	float rand3 = hash(grid + vec2(1.7,  9.5));

	// Per-star flicker
	float flicker = sin(TIME * flicker_speed * (0.5 + rand2) + rand3 * 6.2832);
	flicker = flicker * 0.5 + 0.5;

	bool is_star = rand < star_density;

	vec4 star_col = mix(star_color_1, star_color_2, step(0.5, rand2));
	star_col.a *= flicker;

	vec4 final_color = bg_color;
	if (is_star) {
		final_color = mix(bg_color, star_col, star_col.a);
	}
	COLOR = final_color;
}