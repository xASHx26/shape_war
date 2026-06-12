extends CanvasLayer

const API_URL = "https://quotes15.p.rapidapi.com/quotes/random/?language_code=en"
const API_KEY = "e82f230f93msh830350f1f860b8ep104e91jsn63ab3e3c99a4"

const FONT = preload("res://AlfaSlabOne-Regular.ttf")
const TEX_RETRY = preload("res://SPRITE/arrow-refresh-reload-icon-29.png")
const TEX_HOME = preload("res://SPRITE/61972.png")
const TEX_EXIT = preload("res://SPRITE/logout.png")

@onready var api_good: Label = $Api_good
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var center_container: CenterContainer = $CenterContainer
@onready var bg_rect: TextureRect = $BackgroundBlur
@onready var planet: Sprite2D = $Planet

func _ready() -> void:
	# Try standard load first (if Godot has imported it)
	var bg_tex = load("res://SPRITE/space_bg_nebula.png") as Texture2D
	if not bg_tex:
		# Fallback to direct file loading
		var bg_path = ProjectSettings.globalize_path("res://SPRITE/space_bg_nebula.png")
		var bg_img = Image.new()
		if bg_img.load(bg_path) == OK:
			bg_tex = ImageTexture.create_from_image(bg_img)
	if bg_tex:
		bg_rect.texture = bg_tex

	# Load planet texture dynamically
	var planet_tex = load("res://SPRITE/pixel_planet.png") as Texture2D
	if not planet_tex:
		var planet_path = ProjectSettings.globalize_path("res://SPRITE/pixel_planet.png")
		var planet_img = Image.new()
		if planet_img.load(planet_path) == OK:
			planet_tex = ImageTexture.create_from_image(planet_img)
			
	if planet_tex:
		planet.texture = planet_tex
		
	# Apply Additive Blending to planet
	var p_mat = CanvasItemMaterial.new()
	p_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	planet.material = p_mat

	build_ui()
	_request_quote()

func _process(delta: float) -> void:
	if is_instance_valid(planet):
		planet.rotation += 0.5 * delta

func build_ui() -> void:
	# Panel Style
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.08, 0.95)
	style.border_width_left = 4
	style.border_width_right = 4
	style.border_width_top = 4
	style.border_width_bottom = 4
	style.border_color = Color(0.0, 0.8, 1.0, 1.0) # Cyan border
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	panel.add_theme_stylebox_override("panel", style)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_override("font", FONT)
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	vbox.add_child(title)
	
	# Spacer
	vbox.add_child(HSeparator.new())
	
	# Scores
	var highest = Label.new()
	highest.text = "HIGHEST SCORE: " + str(SaveGame.data.get("score", 0))
	highest.add_theme_font_override("font", FONT)
	highest.add_theme_font_size_override("font_size", 24)
	highest.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(highest)
	
	var score = Label.new()
	score.text = "SCORE: " + str(Global.count)
	score.add_theme_font_override("font", FONT)
	score.add_theme_font_size_override("font_size", 24)
	score.add_theme_color_override("font_color", Color(1, 1, 0)) # Yellow
	score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(score)
	
	var points = Label.new()
	points.text = "POINTS: " + str(SaveGame.data.get("Points", 0))
	points.add_theme_font_override("font", FONT)
	points.add_theme_font_size_override("font_size", 20)
	points.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	points.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(points)
	
	# Spacer
	vbox.add_child(HSeparator.new())
	
	# Buttons Container
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 30)
	vbox.add_child(hbox)
	
	# Retry Button
	var btn_retry = create_icon_button(TEX_RETRY)
	btn_retry.pressed.connect(_on_retry_pressed)
	hbox.add_child(btn_retry)
	
	# Home Button
	var btn_home = create_icon_button(TEX_HOME)
	btn_home.pressed.connect(_on_home_pressed)
	hbox.add_child(btn_home)
	
	# Exit Button
	var btn_exit = create_icon_button(TEX_EXIT)
	btn_exit.pressed.connect(_on_exit_pressed)
	hbox.add_child(btn_exit)
	
	center_container.add_child(panel)

func create_icon_button(tex: Texture2D) -> TextureButton:
	var btn = TextureButton.new()
	btn.texture_normal = tex
	btn.ignore_texture_size = true
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.custom_minimum_size = Vector2(80, 80)
	return btn

func _request_quote() -> void:
	var headers = [
		"x-rapidapi-key: " + API_KEY,
		"x-rapidapi-host: quotes15.p.rapidapi.com"
	]
	http_request.request(API_URL, headers, HTTPClient.METHOD_GET)

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _on_home_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.parse_string(response_text)
		if json and json.has("content"):
			var quote = json["content"]
			var word_count = quote.split(" ", false).size()
			if word_count <= 20:
				api_good.text = quote
			else:
				api_good.text = "Have a good day"
				_request_quote()
		else:
			api_good.text = "Have a good day"
	else:
		api_good.text = "Have a good day"
