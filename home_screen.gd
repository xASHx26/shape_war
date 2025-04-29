extends Control

<<<<<<< HEAD
@onready var Point: Label = $PinkAndBlackRetroGamingDesktopWallpaper/Label
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
=======
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
@onready var Point: Label = $PinkAndBlackRetroGamingDesktopWallpaper/Label
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Point.text=str(SaveGame.data["Points"])
<<<<<<< HEAD
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
=======
	
<<<<<<< HEAD
=======
=======

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
