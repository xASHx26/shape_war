extends Control
@onready var music_player: AudioStreamPlayer = $musicPlayer
@onready var hbox: HBoxContainer = $HBoxContainer

var spectrum = AudioServer.get_bus_effect_instance(1,0)
const VU_COUNT = 60 # Screen-spanning resolution
const HEIGHT = 100
const FREQ_MAX = 11050.0
const MIN_DB = 60

var bars = []

func _ready():
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
		
	# Dynamically generate the visualizer bars
	for i in range(VU_COUNT):
		var bar = ColorRect.new()
		bar.custom_minimum_size = Vector2(20, 0) # 20px width per bar
		bar.size_flags_vertical = Control.SIZE_SHRINK_END # Pin them to the bottom so they grow upwards
		hbox.add_child(bar)
		bars.append(bar)

func _process(delta):
	if Global.curr_health <= 0:
		set_process(false) 
		music_player.stop()
		return
		
	var saved_volume = SaveGame.data.get("Sound", 50)
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	music_player.volume_linear = linear

	var prev_hz = 0
	for i in range(1, VU_COUNT + 1):   
		var hz = i * FREQ_MAX / VU_COUNT;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length())) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
 
		prev_hz = hz
		
		# Snap height to 4-pixel blocks to simulate chunky retro pixels
		var pixel_height = round(height / 4.0) * 4.0
		pixel_height = max(pixel_height, 2.0)
		
		var bar = bars[i-1]
		bar.custom_minimum_size.y = pixel_height
		
		var rainbow_color = Color.from_hsv(float(i - 1) / VU_COUNT, 1.0, 1.0)
		bar.color = rainbow_color
