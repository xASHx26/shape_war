extends Control
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5

func  _process(delta: float) -> void:
	label.text= str("Fps: ",Engine.get_frames_per_second())
	label_2.text=str("Total rocket defeted: ",Global.count)
	label_3.text=str("Total Enemy3 in scene: ",Global.total_enemy3)
	label_4.text=str("Total Enemy1 in scene: ",Global.total_enemy1)
	label_5.text=str("Total Enemy2 in scene: ",Global.total_enemy1)
