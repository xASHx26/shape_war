extends Control
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5
@onready var health: Label = $health
@onready var top_score: Label = $'Top Score'
func _ready() -> void:
	var save=SaveGame.read_save()
func  _process(delta: float) -> void:
	if SaveGame.data.get("Fps")==true:
		
		label.text= str("Fps: ",Engine.get_frames_per_second())
	label_2.text=str(Global.count)
	
	
	if "score" in SaveGame.data:
		var d = (SaveGame.data["score"])
		top_score.text = str(d)
	else:
		top_score.text = "Top score: N/A"  # Handle missing key gracefully

	
