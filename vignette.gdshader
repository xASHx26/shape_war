shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV;
    
    // Pixelate the UV coordinates to give a retro blocky feel
    vec2 pixel_size = vec2(128.0, 72.0);
    vec2 pixel_uv = floor(uv * pixel_size) / pixel_size;
    
    // Calculate distance from center (0.5, 0.5)
    float dist_x = abs(pixel_uv.x - 0.5) * 2.0; // 0 at center, 1 at left/right edges
    float dist_y = abs(pixel_uv.y - 0.5) * 2.0; // 0 at center, 1 at top/bottom edges
    
    // Create a smooth vignette that favors the left and right walls
    float vignette = smoothstep(0.5, 1.0, dist_x) * 0.9 + smoothstep(0.7, 1.0, dist_y) * 0.5;
    vignette = clamp(vignette, 0.0, 1.0);
    
    // Blood red color overlay
    COLOR = vec4(0.8, 0.0, 0.0, vignette * intensity * 0.85); // 0.85 opacity max so you can still see
}
