extends CanvasLayer


@onready var label: Label = $CenterContainer/PanelContainer/Label
@onready var score: Label = $Label
const API_URL = "https://quotes15.p.rapidapi.com/quotes/random/?language_code=en"
const API_KEY = "e82f230f93msh830350f1f860b8ep104e91jsn63ab3e3c99a4"
@onready var total_point = $total_point

@onready var api_good: Label = $Api_good

@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	
	score.text = str( Global.count)
	total_point.text=str(SaveGame.data["Points"])
	_request_quote() 

func _request_quote() -> void:
	var headers = [
		"x-rapidapi-key: " + API_KEY,
		"x-rapidapi-host: quotes15.p.rapidapi.com"
	]
	http_request.request(API_URL, headers, HTTPClient.METHOD_GET)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_home_pressed() -> void:
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
				api_good.text = quote  # Display the quote
			else:
				api_good.text = "Have a good day"
				print("Too long")
				_request_quote()  # Fetch another quote if too long
		else:
			api_good.text = "Have a good day"
			print("failed to fetch api")
	else:
		api_good.text = "Have a good day"
		print("error to fetch api")
