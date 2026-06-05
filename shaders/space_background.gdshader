shader_type canvas_item;

uniform sampler2D base_texture : repeat_enable, filter_linear_mipmap;
uniform vec2 scroll_speed = vec2(0.02, 0.02);
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    // Scale UV to fix horizontal stretching (1152/648 aspect ratio is ~1.77)
    vec2 scaled_uv = UV * vec2(1.77, 1.0);
    vec2 scrolled_uv = scaled_uv + TIME * scroll_speed;
    
    // Mirror the UVs so the edges blend perfectly instead of showing a hard seam
    vec2 mirrored_uv = abs(fract(scrolled_uv * 0.5) * 2.0 - 1.0);
    
    vec4 tex_color = texture(base_texture, mirrored_uv);
    COLOR = tex_color * brightness;
}
