extends Control
@onready var mute = $MarginContainer/VBoxContainer/mute
@onready var volume = $MarginContainer/VBoxContainer/Volume
@onready var music = $MarginContainer/VBoxContainer/Music
@onready var fps = $MarginContainer/VBoxContainer/Fps

func _ready():
	volume.value=SaveGame.data["Sound"]
	mute.button_pressed = SaveGame.data.get("Mute")
	music.select(SaveGame.data.get("Music") - 1)
	fps.button_pressed = SaveGame.data.get("Fps")
	
	
	
func _on_volume_value_changed(value):
	SaveGame.data["Sound"]=value
	SaveGame.Write_save(SaveGame.data)
	


func _on_mute_toggled(toggled_on):
	SaveGame.data["Mute"] = toggled_on
	SaveGame.Write_save(SaveGame.data)
	
	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://home_screen.tscn")





func _on_fps_toggled(toggled_on):
	SaveGame.data["Fps"] = toggled_on
	SaveGame.Write_save(SaveGame.data)


func _on_music_item_selected(index):
	match  index:
		0:
			SaveGame.data["Music"]=1
			SaveGame.Write_save(SaveGame.data)
		1:
			SaveGame.data["Music"]=2
			SaveGame.Write_save(SaveGame.data)
		
		
