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
<<<<<<< HEAD
	if SaveGame.data.get("Fps")==true:
		
		label.text= str("Fps: ",Engine.get_frames_per_second())
=======
	label.text= str("Fps: ",Engine.get_frames_per_second())
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	label_2.text=str(Global.count)
	
	
	if "score" in SaveGame.data:
		var d = (SaveGame.data["score"])
		top_score.text = str(d)
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
=======
	label_2.text=str("Total rocket defeted: ",Global.count)
	label_3.text=str("Total Enemy3 in scene: ",Global.total_enemy3)
	label_4.text=str("Total Enemy1 in scene: ",Global.total_enemy1)
	label_5.text=str("Total Enemy2 in scene: ",Global.total_enemy1)
	health.text=str("Total health: ",Global.curr_health)
	if "score" in SaveGame.data:
		var d = (SaveGame.data["score"])
		top_score.text = str("Top score: ", d)
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	else:
		top_score.text = "Top score: N/A"  # Handle missing key gracefully

	
