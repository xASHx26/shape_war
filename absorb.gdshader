shader_type canvas_item;

uniform float absorb_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 absorb_center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = UV;
    
    // Direction and distance to the center
    vec2 dir = absorb_center - uv;
    float dist = length(dir);
    
    // Spaghettification (pulling UVs away from the center makes the texture look pulled IN)
    // As progress goes up, pixels further away get pulled harder
    vec2 pinched_uv = uv - (dir * dist * absorb_progress * 2.5);
    
    // Add a swirling effect
    float angle = absorb_progress * 10.0 * (1.0 - dist);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(vec2(c, -s), vec2(s, c));
    pinched_uv = (pinched_uv - absorb_center) * rot + absorb_center;
    
    // Pixelation effect increases as it gets absorbed
    float pixel_factor = mix(1.0, 15.0, absorb_progress);
    // Rough estimation of texture size, works well enough for general retro sprites
    vec2 pixel_uv = floor(pinched_uv * (100.0 / pixel_factor)) / (100.0 / pixel_factor);
    
    vec4 tex = texture(TEXTURE, pixel_uv);
    
    // Color tinting towards void energy (purple/dark blue)
    vec3 void_color = vec3(0.4, 0.0, 0.8);
    vec3 final_color = mix(tex.rgb, void_color, absorb_progress * 0.9);
    
    // Fade out opacity right at the end of the absorb
    float alpha = tex.a * (1.0 - pow(absorb_progress, 3.0));
    
    COLOR = vec4(final_color, alpha);
}
