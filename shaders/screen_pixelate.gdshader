shader_type canvas_item;

uniform float scroll_speed_x = 0.05;
uniform float scroll_speed_y = 0.02;

void fragment() {
    vec2 scrolled_uv = UV;
    scrolled_uv.x += TIME * scroll_speed_x;
    scrolled_uv.y += TIME * scroll_speed_y;
    
    vec4 tex_color = texture(TEXTURE, scrolled_uv);
    COLOR = tex_color;
}
