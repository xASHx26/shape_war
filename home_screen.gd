extends Control

@onready var Point: Label = $PinkAndBlackRetroGamingDesktopWallpaper/Label
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Point.text=str(SaveGame.data["Points"])
	var saved_volume = SaveGame.data.get("Sound")
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	audio_stream_player_2d.volume_linear = linear
	if SaveGame.data.get("Mute")==true:
		audio_stream_player_2d.stop()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var saved_volume = SaveGame.data.get("Sound")
	var linear = clamp(saved_volume / 100.0, 0.0, 1.0)
	audio_stream_player_2d.volume_linear = linear
	if SaveGame.data.get("Mute")==true:
		audio_stream_player_2d.stop()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://loadingScreen.tscn")


func _on_option_pressed():
	get_tree().change_scene_to_file("res://setiings.tscn")


func _on_exit_pressed():
	get_tree().quit()
