extends Area2D
var  traved_dis=0
@export var speed=1000

func _physics_process(delta: float) -> void:
	var dir =Vector2.RIGHT.rotated(rotation)
	position+=dir*speed*delta
	traved_dis+=speed*delta
	
	if traved_dis> 1200:
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy1"):
		
		body.health-=1
		
		
		queue_free()
	
	if body.is_in_group("enemy2"):
		
		body.health-=1
		
		
		queue_free()
	if body.is_in_group("enemy3"):
		body.health-=1
		
		
		queue_free()
	
