extends Control

var health_bar: ProgressBar
var hp_label: Label
var shield_bar: ProgressBar
var shield_label: Label
var top_score_label: Label
var current_score_label: Label
var points_label: Label

func _ready() -> void:
	if get_parent() is CanvasLayer:
		get_parent().layer = 100

	for child in get_children():
		child.queue_free()

	# Main Panel (Cyan Border)
	var panel = PanelContainer.new()
	var panel_margin = MarginContainer.new()
	panel_margin.add_theme_constant_override("margin_top", 15)
	panel_margin.add_theme_constant_override("margin_left", 15)
	panel_margin.set_anchors_preset(Control.PRESET_TOP_LEFT)
	add_child(panel_margin)
	panel_margin.add_child(panel)

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.02, 0.02, 0.05, 0.9)
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = Color(0.2, 0.8, 0.9)
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel.add_theme_stylebox_override("panel", panel_style)

	var main_vbox = VBoxContainer.new()
	var inner_margin = MarginContainer.new()
	inner_margin.add_theme_constant_override("margin_top", 15)
	inner_margin.add_theme_constant_override("margin_left", 15)
	inner_margin.add_theme_constant_override("margin_right", 15)
	inner_margin.add_theme_constant_override("margin_bottom", 15)
	panel.add_child(inner_margin)
	inner_margin.add_child(main_vbox)
	main_vbox.add_theme_constant_override("separation", 15)

	# --- HP SECTION ---
	var hp_vbox = VBoxContainer.new()
	main_vbox.add_child(hp_vbox)
	
	var hp_header = HBoxContainer.new()
	hp_vbox.add_child(hp_header)
	
	var heart_icon = Label.new()
	heart_icon.text = "❤️"
	heart_icon.add_theme_font_size_override("font_size", 16)
	hp_header.add_child(heart_icon)
	
	hp_label = Label.new()
	hp_label.add_theme_font_size_override("font_size", 14)
	hp_header.add_child(hp_label)
	
	health_bar = ProgressBar.new()
	health_bar.custom_minimum_size = Vector2(200, 18)
	health_bar.show_percentage = false
	var hp_bg = StyleBoxFlat.new()
	hp_bg.bg_color = Color(0.1, 0.1, 0.1)
	hp_bg.border_width_left = 2
	hp_bg.border_width_right = 2
	hp_bg.border_width_top = 2
	hp_bg.border_width_bottom = 2
	hp_bg.border_color = Color(0.3, 0.4, 0.5)
	health_bar.add_theme_stylebox_override("background", hp_bg)
	var hp_fill = StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.0, 1.0, 0.2) # Bright Green
	health_bar.add_theme_stylebox_override("fill", hp_fill)
	hp_vbox.add_child(health_bar)

	# --- SHIELD SECTION ---
	var sh_vbox = VBoxContainer.new()
	main_vbox.add_child(sh_vbox)
	
	var sh_header = HBoxContainer.new()
	sh_vbox.add_child(sh_header)
	
	var sh_icon = Label.new()
	sh_icon.text = "🛡️"
	sh_icon.add_theme_font_size_override("font_size", 16)
	sh_header.add_child(sh_icon)
	
	shield_label = Label.new()
	shield_label.add_theme_font_size_override("font_size", 14)
	sh_header.add_child(shield_label)
	
	shield_bar = ProgressBar.new()
	shield_bar.custom_minimum_size = Vector2(200, 18)
	shield_bar.show_percentage = false
	var sh_bg = StyleBoxFlat.new()
	sh_bg.bg_color = Color(0.1, 0.1, 0.1)
	sh_bg.border_width_left = 2
	sh_bg.border_width_right = 2
	sh_bg.border_width_top = 2
	sh_bg.border_width_bottom = 2
	sh_bg.border_color = Color(0.3, 0.4, 0.5)
	shield_bar.add_theme_stylebox_override("background", sh_bg)
	var sh_fill = StyleBoxFlat.new()
	sh_fill.bg_color = Color(1.0, 0.8, 0.0) # Yellow
	shield_bar.add_theme_stylebox_override("fill", sh_fill)
	sh_vbox.add_child(shield_bar)

	# --- SCORES SECTION ---
	var score_vbox = VBoxContainer.new()
	main_vbox.add_child(score_vbox)
	score_vbox.add_theme_constant_override("separation", 2)
	
	top_score_label = Label.new()
	top_score_label.add_theme_font_size_override("font_size", 16)
	score_vbox.add_child(top_score_label)
	
	current_score_label = Label.new()
	current_score_label.add_theme_font_size_override("font_size", 16)
	current_score_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.0))
	score_vbox.add_child(current_score_label)
	
	points_label = Label.new()
	points_label.add_theme_font_size_override("font_size", 14)
	score_vbox.add_child(points_label)

func _process(delta: float) -> void:
	health_bar.max_value = Global.max_heath
	health_bar.value = Global.curr_health
	hp_label.text = "HP: " + str(Global.curr_health) + "/" + str(Global.max_heath)
	
	shield_bar.max_value = Global.max_shield
	shield_bar.value = Global.shield_health
	shield_label.text = "SHIELD: " + str(Global.shield_health) + "/" + str(Global.max_shield)
	
	current_score_label.text = "SCORE: " + str(Global.count)
	
	if "score" in SaveGame.data:
		top_score_label.text = "HIGHEST SCORE: " + str(SaveGame.data["score"])
	else:
		top_score_label.text = "HIGHEST SCORE: 0"
		
	if "Points" in SaveGame.data:
		points_label.text = "POINTS: " + str(SaveGame.data["Points"])
	else:
		points_label.text = "POINTS: 0"
