extends Sprite2D
@onready var parent=$".."
var presing=false
@export var maxlength=50
@export var deadzone=5

func _ready() -> void:
	maxlength*=parent.scale.x*10
func _process(delta: float) -> void:
	if presing:
		if get_global_mouse_position().distance_to(parent.global_position)<=maxlength:
			global_position=get_global_mouse_position()
		else :
			var angle=parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x=parent.global_position.x+cos(angle)*maxlength
			global_position.y=parent.global_position.y+sin(angle)*maxlength
		calculatvec()
	else :
		global_position=lerp(global_position,parent.global_position,delta*10)
	print(parent.posVector)	
		
func calculatvec():
	if abs((global_position.x-parent.global_position.x))>=deadzone:
		parent.posVector.x=(global_position.x-parent.global_position.x)/maxlength
	if abs((global_position.y-parent.global_position.y))>=deadzone:
		parent.posVector.y=(global_position.x-parent.global_position.y)/maxlength	
func _on_button_button_down() -> void:
	presing=true


func _on_button_button_up() -> void:
	presing=false
