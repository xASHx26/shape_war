extends Control
@onready var music_player: AudioStreamPlayer = $musicPlayer


var spectrum = AudioServer.get_bus_effect_instance(1,0)
 
@onready
var topRightArray = $circcle/right/top.get_children()
 
@onready
var bottomRightArray = $circcle/right/bottom.get_children()
 
@onready
var topLeftArray = $circcle/left/top.get_children()
 
@onready
var bottomLeftArray = $circcle/left/bottom.get_children()
 
const VU_COUNT = 20
const HEIGHT = 60
const FREQ_MAX = 11050.0
var data = {}
const MIN_DB = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	bottomLeftArray.reverse()
	topLeftArray.reverse()
	var saved_volume = SaveGame.data.get("Sound")
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	music_player.volume_linear = linear
	if SaveGame.data.get("Mute")==true:
		music_player.stop()
	var music_choice = SaveGame.data.get("Music")

	var stream: Resource = null

	match music_choice:
		1:
			stream = load("res://audio/mixkit-born-620.mp3")
		2:
			stream = load("res://audio/mixkit-space-game-668.mp3")
		3:
			stream = load("uid://your_music3_uid_here")


	if stream:
		music_player.stream = stream

		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.curr_health<=0:
		set_process(false) 
		music_player.stop()
	var saved_volume = SaveGame.data.get("Sound")
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	music_player.volume_linear = linear

	var prev_hz = 0
	for i in range(1,VU_COUNT+1):   
		var hz = i * FREQ_MAX / VU_COUNT;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length()))/MIN_DB,0,1)
		var height = energy * HEIGHT
 
		prev_hz = hz
 
		var bottomRightRect = bottomRightArray[i - 1]
 
		var topRightRect = topRightArray[i - 1]
 
		var topLeftRect = topLeftArray[i - 1]
 
		var bottomLeftRect = bottomLeftArray[i - 1]
 
		var tween = get_tree().create_tween()
 
		tween.tween_property(topRightRect, "size", Vector2(topRightRect.size.x, height), 0.05)
 
		tween.tween_property(bottomRightRect, "size", Vector2(bottomRightRect.size.x, height), 0.05)
 
		tween.tween_property(topLeftRect, "size", Vector2(topLeftRect.size.x, height), 0.05)
 
		tween.tween_property(bottomLeftRect, "size", Vector2(bottomLeftRect.size.x, height), 0.05)
		var music_choice = SaveGame.data.get("Music")

		var stream: Resource = null

		match music_choice:
			1:
				stream = load("res://audio/mixkit-born-620.mp3")
			2:
				stream = load("res://audio/mixkit-space-game-668.mp3")
			3:
				stream = load("uid://your_music3_uid_here")
