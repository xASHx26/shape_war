extends Control
 
@onready
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
const HEIGHT = 80
const FREQ_MAX = 11050.0
 
const MIN_DB = 80
 
# Called when the node enters the scene tree for the first time.
func _ready():
	bottomLeftArray.reverse()
	topLeftArray.reverse()
 
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 
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
