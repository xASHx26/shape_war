extends Control
@onready var label: Label = $Label
@onready var label_2: Label = $Label2

func  _process(delta: float) -> void:
	label.text= str("Fps: ",Engine.get_frames_per_second())
	label_2.text=str("Total rocket defeted: ",Global.count)
