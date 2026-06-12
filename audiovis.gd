extends Control
@onready var music_player: AudioStreamPlayer = $musicPlayer

var spectrum = AudioServer.get_bus_effect_instance(1, 0)
const VU_COUNT = 120
const FREQ_MAX = 8000.0
const MIN_DB = 60.0
const WAVE_HEIGHT = 80.0  # Max amplitude of the wave from center

var smoothed_energies := []
var time_accum := 0.0

func _ready():
	# Hide the old HBoxContainer if it still exists
	if has_node("HBoxContainer"):
		$HBoxContainer.queue_free()

	var saved_volume = SaveGame.data.get("Sound", 50)
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	music_player.volume_linear = linear
	if SaveGame.data.get("Mute") == true:
		music_player.stop()
		
	var music_choice = SaveGame.data.get("Music", 1)
	var stream: Resource = null
	match music_choice:
		1: stream = load("res://audio/mixkit-born-620.mp3")
		2: stream = load("res://audio/mixkit-space-game-668.mp3")
		3: stream = load("uid://your_music3_uid_here")

	if stream:
		music_player.stream = stream
		if not music_player.playing and SaveGame.data.get("Mute") != true:
			music_player.play()
	
	for i in range(VU_COUNT):
		smoothed_energies.append(0.0)

func _process(delta):
	if Global.curr_health <= 0:
		set_process(false)
		music_player.stop()
		return
	
	var saved_volume = SaveGame.data.get("Sound", 50)
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	music_player.volume_linear = linear
	
	time_accum += delta
	
	var prev_hz = 0.0
	for i in range(VU_COUNT):
		var hz = (i + 1) * FREQ_MAX / VU_COUNT
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length())) / MIN_DB, 0.0, 1.0)
		prev_hz = hz
		
		# Smooth interpolation for fluid motion
		smoothed_energies[i] = lerp(smoothed_energies[i], energy, clamp(12.0 * delta, 0.0, 1.0))
	
	queue_redraw()

func _draw():
	# The Control has zero size because it's parented to a Node2D, 
	# so we use the viewport size and offset by our own position.
	var vp_size = get_viewport_rect().size
	var my_pos = global_position
	var center_y = vp_size.y / 2.0 - my_pos.y
	var width = vp_size.x
	
	if width <= 0 or vp_size.y <= 0:
		return
	
	var spacing = width / float(VU_COUNT - 1)
	
	# Colors: cyan and magenta/pink like the reference
	var cyan = Color(0.15, 0.85, 1.0, 0.9)
	var magenta = Color(0.95, 0.2, 0.95, 0.9)
	
	# Build the wave using sine modulation driven by spectrum energy
	var top_line = PackedVector2Array()
	var bottom_line = PackedVector2Array()
	var top_colors = PackedColorArray()
	var bottom_colors = PackedColorArray()
	
	for i in range(VU_COUNT):
		var x = i * spacing - my_pos.x
		var energy = smoothed_energies[i]
		
		# Create an oscillating wave shape driven by audio energy
		# Use sine waves at different phases for the two lines
		var wave_phase = float(i) / VU_COUNT * TAU * 4.0 + time_accum * 2.5
		var amplitude = energy * WAVE_HEIGHT
		
		# Top wave: sin-driven displacement
		var y_top = center_y + sin(wave_phase) * amplitude
		# Bottom wave: offset phase so they cross over each other
		var y_bottom = center_y + sin(wave_phase + PI * 0.6) * amplitude
		
		top_line.append(Vector2(x, y_top))
		bottom_line.append(Vector2(x, y_bottom))
		
		# Gradient: cyan on left -> magenta on right
		var t = float(i) / float(VU_COUNT - 1)
		top_colors.append(cyan.lerp(magenta, t))
		bottom_colors.append(magenta.lerp(cyan, t))
	
	# Draw glow layers (thicker, more transparent lines behind)
	var glow_cyan = Color(0.15, 0.85, 1.0, 0.15)
	var glow_magenta = Color(0.95, 0.2, 0.95, 0.15)
	var glow_top_colors = PackedColorArray()
	var glow_bottom_colors = PackedColorArray()
	for i in range(VU_COUNT):
		var t = float(i) / float(VU_COUNT - 1)
		glow_top_colors.append(glow_cyan.lerp(glow_magenta, t))
		glow_bottom_colors.append(glow_magenta.lerp(glow_cyan, t))
	
	draw_polyline_colors(top_line, glow_top_colors, 8.0, true)
	draw_polyline_colors(bottom_line, glow_bottom_colors, 8.0, true)
	
	# Draw main lines
	draw_polyline_colors(top_line, top_colors, 2.5, true)
	draw_polyline_colors(bottom_line, bottom_colors, 2.5, true)
