shader_type canvas_item;

uniform vec4 core_color : source_color = vec4(1.0, 0.9, 0.4, 1.0);
uniform vec4 edge_color : source_color = vec4(1.0, 0.2, 0.0, 1.0);
uniform vec4 tail_color : source_color = vec4(0.0, 0.5, 1.0, 0.0);
uniform float speed = 10.0;

void fragment() {
    vec2 uv = UV;
    
    // Create a rocket/bullet shape (elongated on X axis, assuming bullet travels along X or Y)
    // Actually, in Godot 2D, the default bullet rotation might point it along the X axis.
    
    // The bullet travels UP (negative Y axis).
    // So the tip is at uv.y = 0.0, and the tail is at uv.y = 1.0.
    float y_shape = 1.0 - uv.y; // 1 at tip, 0 at tail
    float x_dist = abs(uv.x - 0.5) * 2.0; 
    
    // Taper the shape based on Y (thicker at head, thin at tail)
    float thickness = smoothstep(0.0, 0.8, y_shape) * smoothstep(1.0, 0.8, y_shape);
    
    // Add animated noise for the fire effect
    float time_val = TIME * speed;
    float noise = fract(sin(dot(uv + vec2(0.0, -time_val), vec2(12.9898, 78.233))) * 43758.5453);
    
    float fire_intensity = thickness - x_dist;
    fire_intensity += noise * 0.15 * (1.0 - y_shape); // More noise at the tail
    
    if (fire_intensity <= 0.0) {
        COLOR = vec4(0.0);
    } else {
        // Core is bright yellow/white, edges are red/orange, tail fades out
        float gradient = smoothstep(0.0, 0.5, fire_intensity);
        vec4 color = mix(edge_color, core_color, gradient);
        
        // Fade the tail
        float alpha = smoothstep(0.0, 0.3, y_shape);
        color.a *= alpha;
        
        COLOR = color;
    }
}
