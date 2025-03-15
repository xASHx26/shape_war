extends Control

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
@onready var Point: Label = $PinkAndBlackRetroGamingDesktopWallpaper/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Point.text=str(SaveGame.data["Points"])
	
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
