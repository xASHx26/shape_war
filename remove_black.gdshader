shader_type canvas_item;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    // If the pixel is very dark (almost black), make it fully transparent
    if (tex.r < 0.05 && tex.g < 0.05 && tex.b < 0.05) {
        tex.a = 0.0;
    }
    COLOR = tex;
}
