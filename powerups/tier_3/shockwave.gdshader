shader_type canvas_item;

uniform vec4 wave_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float thickness : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);
	
	// Create a ring shape
	float outer = 1.0 - smoothstep(0.45, 0.5, dist);
	float inner = smoothstep(0.5 - thickness - 0.05, 0.5 - thickness, dist);
	
	float ring = outer * inner;
	
	// Add some high intensity center for a glowing effect
	float glow = smoothstep(0.5 - thickness, 0.5, dist);
	
	COLOR = wave_color;
	COLOR.a *= ring;
}
