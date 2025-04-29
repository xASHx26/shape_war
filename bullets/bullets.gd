extends Area2D
var  traved_dis=0
@export var speed=4000

<<<<<<< HEAD
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		set_process(false) 
=======
<<<<<<< HEAD
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		set_process(false) 
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
func _physics_process(delta: float) -> void:
	var dir =Vector2.RIGHT.rotated(rotation)
	position+=dir*speed*delta
	traved_dis+=speed*delta
	
	if traved_dis> 1200:
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy1"):
		Global.count += 5
		
		body.queue_free()
		
		queue_free()
	
	if body.is_in_group("enemy2"):
		Global.count += 3
		
		body.queue_free()
		
		queue_free()
	
	
