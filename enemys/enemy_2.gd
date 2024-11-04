extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3

@onready var rotator: RayCast2D = $rotator
@onready var rotator_2: RayCast2D = $rotator2
@onready var ray_cast_2d_4: RayCast2D = $RayCast2D4
@onready var ray_cast_2d_5: RayCast2D = $RayCast2D5
@onready var ray_cast_2d_6: RayCast2D = $RayCast2D6
@onready var right_point_enemy_2: Marker2D = %right_point_enemy2
@onready var left_point_enemy_3: Marker2D = %left_point_enemy3
@onready var up_point_enemy_4: Marker2D = %up_point_enemy4

@export var rotation_speed = 10.0 

var follow:=false

		
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false:
		var direction =global_position.direction_to(player.global_position)
		velocity=direction*speed*delta
		var tween=create_tween()
		move_and_slide()
		
		
	else :
		get_tree().reload_current_scene()
func increase_speed():
	speed=8000
func dec_speed():
	speed=100
	print(speed)

func shoot():
	var new_bullet=preload('res://bullets/enemy2_bullets.tscn').instantiate()
	new_bullet.global_position=%shotting_point_enemy.global_position
	new_bullet.global_rotation=%shotting_point_enemy.global_rotation
	add_child(new_bullet)
func shoot_up():
	var new_bullet=preload('res://bullets/enemy2_bullets.tscn').instantiate()
	new_bullet.global_position=%up_point_enemy4.global_position
	new_bullet.global_rotation=%up_point_enemy4.global_rotation
	add_child(new_bullet)	
func shoot_left():
	var new_bullet=preload('res://bullets/enemy2_bullets.tscn').instantiate()
	new_bullet.global_position=%left_point_enemy_3.global_position
	new_bullet.global_rotation=%left_point_enemy_3.global_rotation
	add_child(new_bullet)	
func shoot_right():
	var new_bullet=preload('res://bullets/enemy2_bullets.tscn').instantiate()
	new_bullet.global_position=%right_point_enemy2.global_position
	new_bullet.global_rotation=%right_point_enemy2.global_rotation
	add_child(new_bullet)	

func _on_timer_timeout() -> void:
	if Global.curr_health>0:
		if ray_cast_2d.is_colliding() and collision_layer ==10:
			shoot()
			
		elif  ray_cast_2d_2.is_colliding() and collision_layer ==10:
			shoot()
		elif  ray_cast_2d_3.is_colliding() and collision_layer ==10:
			shoot()
		elif  ray_cast_2d_4.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  rotator.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  ray_cast_2d_6.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  rotator.is_colliding() and collision_layer ==10:
			shoot_left()
		elif  rotator_2.is_colliding() and collision_layer ==10:
			shoot_right()
