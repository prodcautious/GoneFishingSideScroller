shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0, 1.0) = 1.0;

void fragment() {
    vec4 current = texture(TEXTURE, UV);
    
    // Sample the 4 neighboring pixels
    vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;
    
    float alpha_up    = texture(TEXTURE, UV + vec2(0.0,  pixel_size.y)).a;
    float alpha_down  = texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a;
    float alpha_left  = texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a;
    float alpha_right = texture(TEXTURE, UV + vec2( pixel_size.x, 0.0)).a;
    
    // If any neighbor is solid but current pixel is transparent, it's an outline pixel
    float neighbor_alpha = max(max(alpha_up, alpha_down), max(alpha_left, alpha_right));
    
    if (current.a < 0.1 && neighbor_alpha > 0.1) {
        COLOR = outline_color;
    } else {
        COLOR = current;
    }
}