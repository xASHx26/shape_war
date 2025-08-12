extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var left_side: RayCast2D = $left_side
@onready var right_side: RayCast2D = $right_side
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var deathPrticle:PackedScene
@onready var ray_cast_2d_4: RayCast2D = $RayCast2D4
@onready var ray_cast_2d_5: RayCast2D = $RayCast2D5
@onready var ray_cast_2d_6: RayCast2D = $RayCast2D6
@onready var right_point_enemy_2: Marker2D = %right_point_enemy2
@onready var left_point_enemy_3: Marker2D = %left_point_enemy3
@onready var up_point_enemy_4: Marker2D = %up_point_enemy4
@onready var left_2d: Marker2D = $left_2D
@onready var right_2d: Marker2D = $right_2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var rotation_speed = 10.0 
var health:=2
var follow:=false

		
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false:
		var direction =global_position.direction_to(player.global_position)
		velocity=direction*speed*delta
		
		move_and_slide()
		

func kill():
	if health<=0:
		Global.count += 3
		SaveGame.data["Points"]+=3
		SaveGame.Write_save(SaveGame.data)
		explo()
		queue_free()

func explo():
	var explosion = deathPrticle.instantiate()
	get_parent().add_child(explosion)  # Attach to scene
	explosion.global_position = global_position  # Set explosion position
	explosion.emitting = true	
func increase_speed():
	speed=8000
func dec_speed():
	speed=100
	

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
	new_bullet.global_position=%left_2D.global_position
	new_bullet.global_rotation=%left_2D.global_rotation
	add_child(new_bullet)	
	
func shoot_right():
	var new_bullet=preload('res://bullets/enemy2_bullets.tscn').instantiate()
	
	new_bullet.global_position=%right_2D.global_position
	new_bullet.global_rotation=%right_2D.global_rotation
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
		elif  ray_cast_2d_5.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  ray_cast_2d_6.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  right_side.is_colliding() and collision_layer ==10:
			
			shoot_left()
		elif  left_side.is_colliding() and collision_layer ==10:
			shoot_right()
