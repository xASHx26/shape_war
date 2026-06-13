extends CanvasLayer

@export var freeze_duration: float = 5.0
@onready var timer_label: Label = $TimerLabel
@onready var color_rect: ColorRect = $ColorRect

var remaining_time: float = 0.0
var bgm: AudioStreamPlayer2D = null
var original_bgm_volume: float = 0.0

func _ready():
	remaining_time = freeze_duration
	Global.is_time_frozen = true
	
	# Visual effect: blue tint
	color_rect.color = Color(0, 0.2, 0.5, 0.4)
	
	# Find background music
	# In ShapeWar, it might be an AudioStreamPlayer2D on the main scene or spaceship
	var players = get_tree().get_nodes_in_group("bgm")
	if players.size() > 0:
		bgm = players[0]
	else:
		# Try to find any playing AudioStreamPlayer in the scene root
		for child in get_tree().current_scene.get_children():
			if child is AudioStreamPlayer or child is AudioStreamPlayer2D:
				if child.playing:
					bgm = child
					break
					
	if bgm:
		original_bgm_volume = bgm.volume_db
		var tween = create_tween()
		tween.tween_property(bgm, "volume_db", -20.0, 1.0) # Fade out slightly

func _process(delta):
	remaining_time -= delta
	if remaining_time <= 0:
		timer_label.text = "0.0"
		end_chrono_shift()
		set_process(false)
	else:
		timer_label.text = "%.1f" % remaining_time

func add_time(amount: float):
	remaining_time += amount

func end_chrono_shift():
	Global.is_time_frozen = false
	
	# Fade music back in
	if bgm:
		var tween = create_tween()
		tween.tween_property(bgm, "volume_db", original_bgm_volume, 1.0)
		
	# Fade out visual effect
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
