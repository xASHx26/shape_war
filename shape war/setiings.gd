extends Control
@onready var label: Label = $VBoxContainer/Label
@onready var volume_2: Label = $VBoxContainer/Volume2
@onready var volume: HSlider = $VBoxContainer/Volume
@onready var mute: CheckBox = $VBoxContainer/mute
@onready var fps: CheckBox = $VBoxContainer/Fps
@onready var main: Button = $VBoxContainer/Main


func _ready():
	volume.value = SaveGame.data["Sound"]
	mute.button_pressed = SaveGame.data.get("Mute")
	fps.button_pressed = SaveGame.data.get("Fps")

	

	
	
	
func _on_volume_value_changed(value):
	SaveGame.data["Sound"]=value
	SaveGame.Write_save(SaveGame.data)
	


func _on_mute_toggled(toggled_on):
	SaveGame.data["Mute"] = toggled_on
	SaveGame.Write_save(SaveGame.data)
	
	








func _on_fps_toggled(toggled_on):
	SaveGame.data["Fps"] = toggled_on
	SaveGame.Write_save(SaveGame.data)


func _on_touch_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://home_screen.tscn")
