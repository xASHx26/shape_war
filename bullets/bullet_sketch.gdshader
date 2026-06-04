shader_type canvas_item;

uniform vec4 rocket_color : source_color = vec4(0.9, 0.9, 0.9, 1.0);
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fire_core : source_color = vec4(1.0, 0.9, 0.2, 1.0);
uniform vec4 fire_edge : source_color = vec4(1.0, 0.2, 0.0, 1.0);

// Basic 2D noise
float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;
    
    // Dimensions
    float tip_y = 0.15;
    float base_y = 0.6;
    float half_width = 0.18;
    float thick = 0.04; // outline thickness
    
    // ROCKET BODY FILL
    float is_body = step(0.5 - half_width, uv.x) * (1.0 - step(0.5 + half_width, uv.x)) * step(tip_y, uv.y) * (1.0 - step(base_y, uv.y));
    float tip_dist = distance(vec2(uv.x, uv.y * 1.2), vec2(0.5, tip_y * 1.2)); // Slight ellipse for tip
    float is_tip = step(tip_dist, half_width) * (1.0 - step(tip_y, uv.y)); 
    float rocket_fill = clamp(is_body + is_tip, 0.0, 1.0);
    
    // ROCKET OUTLINE
    float out_body = step(0.5 - half_width - thick, uv.x) * (1.0 - step(0.5 + half_width + thick, uv.x)) * step(tip_y, uv.y) * (1.0 - step(base_y + thick, uv.y));
    float tip_dist_out = distance(vec2(uv.x, uv.y * 1.2), vec2(0.5, tip_y * 1.2));
    float out_tip = step(tip_dist_out, half_width + thick) * (1.0 - step(tip_y, uv.y));
    float rocket_outline = clamp(out_body + out_tip, 0.0, 1.0) - rocket_fill;
    rocket_outline = clamp(rocket_outline, 0.0, 1.0);
    
    // FIRE
    float fire_start = base_y + thick;
    float fire_y_norm = (uv.y - fire_start) / (1.0 - fire_start); 
    
    float time_val = TIME * 20.0; // Fast fire animation
    // Blocky noise for jagged pixel-art style fire
    float noise1 = random(floor(uv * 15.0) + vec2(0.0, -floor(time_val)));
    float noise2 = random(floor(uv * 30.0) + vec2(floor(time_val * 0.5), -floor(time_val * 1.2)));
    float fire_noise = (noise1 + noise2) * 0.5;
    
    // Fire width: wider at the base of the rocket, like the sketch
    float fire_width_base = half_width + 0.07; 
    float fire_width = fire_width_base - fire_y_norm * 0.15 + fire_noise * 0.05;
    float dist_x = abs(uv.x - 0.5);
    
    float is_fire = step(dist_x, fire_width) * step(fire_start, uv.y);
    
    // Jagged bottom edge
    float bottom_edge = 0.75 + fire_noise * 0.25; 
    is_fire *= (1.0 - step(bottom_edge, uv.y));
    
    vec4 final_color = vec4(0.0);
    
    if (rocket_outline > 0.0) {
        final_color = outline_color;
    } else if (rocket_fill > 0.0) {
        // Subtle vertical gradient on the rocket body
        final_color = mix(rocket_color, vec4(0.7, 0.7, 0.75, 1.0), uv.x);
    } else if (is_fire > 0.0) {
        // Fire gradient: yellow core to red edges
        float gradient = fire_y_norm + fire_noise * 0.4;
        final_color = mix(fire_core, fire_edge, gradient);
    }
    
    COLOR = final_color;
}
