extends Control

var data = {} # JSON data from file

@onready var single_ammo: Sprite2D = $HBoxContainer/singleAmmo
@onready var single_select: Button = $HBoxContainer/singleAmmo/SingleSelect
@onready var singletouch: TouchScreenButton = $HBoxContainer/singleAmmo/SingleSelect/Singletouch

@onready var double_ammo: Sprite2D = $HBoxContainer/DoubleAmmo
@onready var double_select: Button = $HBoxContainer/DoubleAmmo/DoubleSelect
@onready var price: Label = $HBoxContainer/DoubleAmmo/price
@onready var double_touch: TouchScreenButton = $HBoxContainer/DoubleAmmo/DoubleSelect/DoubleTouch

func _ready() -> void:
	load_data()
	price.text = "200"

	# Show correct colors right at start
	update_button_colors()

	# Connect buttons
	single_select.pressed.connect(on_single_selected)
	double_select.pressed.connect(on_double_selected)

func load_data():
	var file = FileAccess.open("user://data.json", FileAccess.READ)
	if file:
		data = JSON.parse_string(file.get_as_text())
	else:
		data = {
			"score": 0,
			"player_ship": 0,
			"Points": 0,
			"Sound": 100,
			"Mute": false,
			"Fps": false,
			"Skins": {"Double": 0}
		}

func save_data():
	var file = FileAccess.open("user://data.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func on_single_selected():
	data["player_ship"] = 0
	update_button_colors()
	save_data()

func on_double_selected():
	if data["Skins"]["Double"] == 1:
		# Already unlocked, just select
		data["player_ship"] = 1
		update_button_colors()
		save_data()
	elif data["Points"] >= 200:
		# Buy + select
		data["Points"] -= 200
		data["player_ship"] = 1
		data["Skins"]["Double"] = 1
		update_button_colors()
		save_data()
	else:
		print("Not enough points!")

func update_button_colors():
	if data["player_ship"] == 0:
		single_select.modulate = Color(1, 1, 0) # yellow (selected)
		double_select.modulate = Color(0, 1, 0) if data["Skins"]["Double"] == 1 else Color(1, 0, 0)
	else:
		double_select.modulate = Color(1, 1, 0) # yellow (selected)
		single_select.modulate = Color(0, 1, 0)

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://home_screen.tscn")
