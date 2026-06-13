shader_type canvas_item;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    // Cut off everything outside a circle to remove the square background
    if (dist > 0.45) {
        COLOR.a = 0.0;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}
