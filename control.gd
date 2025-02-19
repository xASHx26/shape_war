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
	label.text= str("Fps: ",Engine.get_frames_per_second())
	label_2.text=str("Total rocket defeted: ",Global.count)
	label_3.text=str("Total Enemy3 in scene: ",Global.total_enemy3)
	label_4.text=str("Total Enemy1 in scene: ",Global.total_enemy1)
	label_5.text=str("Total Enemy2 in scene: ",Global.total_enemy1)
	health.text=str("Total health: ",Global.curr_health)
	if "score" in SaveGame.data:
		var d = (SaveGame.data["score"])
		top_score.text = str("Top score: ", d)
	else:
		top_score.text = "Top score: N/A"  # Handle missing key gracefully

	
