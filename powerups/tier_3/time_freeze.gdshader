shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 bg_color = texture(screen_texture, SCREEN_UV);
	
	// Convert to grayscale
	float gray = dot(bg_color.rgb, vec3(0.299, 0.587, 0.114));
	
	// Add a slight cyan tint to the grayscale
	vec3 tinted = mix(vec3(gray), vec3(0.1, 0.4, 0.6), 0.3);
	
	// Apply a subtle vignette
	float dist = distance(SCREEN_UV, vec2(0.5));
	tinted -= dist * 0.5;
	
	COLOR = vec4(tinted, 1.0);
}
