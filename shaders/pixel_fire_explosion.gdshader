shader_type canvas_item;

uniform float explosion_progress : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_size = 4.0;
uniform vec4 fire_color1 : source_color = vec4(1.0, 0.9, 0.2, 1.0); // Yellow
uniform vec4 fire_color2 : source_color = vec4(1.0, 0.4, 0.0, 1.0); // Orange
uniform vec4 fire_color3 : source_color = vec4(1.0, 0.1, 0.0, 1.0); // Red
uniform vec4 ash_color : source_color = vec4(0.2, 0.2, 0.2, 1.0); // Ash

// Pseudo-random noise function
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Simple 2D noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    // Quantize UVs for pixelation
    vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 pixel_uv = floor(UV * tex_size / pixel_size) * pixel_size / tex_size;
    
    vec4 base_color = texture(TEXTURE, pixel_uv);
    
    // Only process non-transparent pixels
    if (base_color.a > 0.1) {
        // Generate noise based on pixel UV and time
        float n = noise(pixel_uv * 10.0 + TIME * 2.0);
        
        // Dissolve threshold based on progress and noise
        // Upward bias: burn from top to bottom or random
        float burn_threshold = explosion_progress * 1.5;
        
        if (n < burn_threshold - 0.3) {
            discard; // Fully burned away
        } else if (n < burn_threshold) {
            // Edge of the burn (Fire)
            float fire_stage = (burn_threshold - n) / 0.3;
            
            vec4 fire_col;
            if (fire_stage > 0.6) {
                fire_col = fire_color1;
            } else if (fire_stage > 0.3) {
                fire_col = fire_color2;
            } else if (fire_stage > 0.1) {
                fire_col = fire_color3;
            } else {
                fire_col = ash_color;
            }
            COLOR = fire_col;
        } else {
            // Not burned yet, maybe tint slightly orange as it gets close
            if (explosion_progress > 0.0) {
                 float heat = max(0.0, 1.0 - (n - burn_threshold) * 2.0);
                 COLOR = mix(base_color, fire_color1, heat * 0.3 * explosion_progress);
            } else {
                 COLOR = base_color;
            }
        }
    } else {
        COLOR = base_color;
    }
}
