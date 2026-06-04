extends Area2D
var  traved_dis=0
@export var speed=1000
@export var damage: int = 1
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		set_process(false) 
func _physics_process(delta: float) -> void:
	var dir =Vector2.RIGHT.rotated(rotation)
	position+=dir*speed*delta
	traved_dis+=speed*delta
	
	if traved_dis> 1200:
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
