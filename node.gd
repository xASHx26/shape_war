extends Node

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

<<<<<<< HEAD

=======
# Called when the node enters the scene tree for the first time.
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
func _ready() -> void:
	audio_stream_player_2d.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
