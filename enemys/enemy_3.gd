extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var left_side: RayCast2D = $left_side
@onready var right_side: RayCast2D = $right_side
@onready var left_side_2: RayCast2D = $left_side2
@onready var left_side_3: RayCast2D = $left_side3
@onready var right_side_2: RayCast2D = $right_side2
@onready var right_side_3: RayCast2D = $right_side3
@export var deathPrticle:PackedScene
@onready var ray_cast_2d_4: RayCast2D = $RayCast2D4
@onready var ray_cast_2d_5: RayCast2D = $RayCast2D5
@onready var ray_cast_2d_6: RayCast2D = $RayCast2D6
@onready var right_point_enemy_2: Marker2D = %right_point_enemy2
@onready var left_point_enemy_3: Marker2D = %left_point_enemy3
@onready var up_point_enemy_4: Marker2D = %up_point_enemy4
@onready var left_2d: Marker2D = $left_2D
@onready var right_2d: Marker2D = $right_2D
@onready var up_canon: MeshInstance2D = $up_canon
@onready var down_canon: MeshInstance2D = $down_canon
@onready var right_canon: MeshInstance2D = $right_canon
@onready var left_canon: MeshInstance2D = $left_canon
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var rotation_speed = 10.0 
<<<<<<< HEAD
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
=======
<<<<<<< HEAD
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e

var follow:=false

var health:=1		
func _ready() -> void:
	pass
func _process(delta: float) -> void:
<<<<<<< HEAD
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
=======
<<<<<<< HEAD
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false:
		
		
		pass
		
	
func kill():
	if health<=0:
		Global.count += 5
<<<<<<< HEAD
		SaveGame.data["Points"]+=5
		SaveGame.Write_save(SaveGame.data)
=======
<<<<<<< HEAD
		SaveGame.data["Points"]+=5
		SaveGame.Write_save(SaveGame.data)
=======
<<<<<<< HEAD
		SaveGame.data["Points"]+=5
		SaveGame.Write_save(SaveGame.data)
=======
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
		explo()
		queue_free()
		
func explo():
	var explosion = deathPrticle.instantiate()
	get_parent().add_child(explosion)  # Attach to scene
	explosion.global_position = collision_shape_2d.global_position  # Set explosion position
	explosion.emitting = true
func increase_speed():
	speed=8000
func dec_speed():
	speed=100
	
func canon_look():
	var Player_direction =player.global_position
	if ray_cast_2d.is_colliding() and collision_layer ==10:
			
		down_canon.look_at(Player_direction)
			
	elif  ray_cast_2d_2.is_colliding() and collision_layer ==10:
		down_canon.look_at(Player_direction)
	elif  ray_cast_2d_3.is_colliding() and collision_layer ==10:
		down_canon.look_at(Player_direction)
	elif  ray_cast_2d_4.is_colliding() and collision_layer ==10:
		up_canon.look_at(Player_direction)
	elif  ray_cast_2d_5.is_colliding() and collision_layer ==10:
		up_canon.look_at(Player_direction)
	elif  ray_cast_2d_6.is_colliding() and collision_layer ==10:
		up_canon.look_at(Player_direction)
	elif  right_side.is_colliding() and collision_layer ==10:
		left_canon.look_at(Player_direction)
	elif left_side_2.is_colliding() and collision_layer==10:
		right_canon.look_at(Player_direction)	
	elif  left_side.is_colliding() and collision_layer ==10:
		right_canon.look_at(Player_direction)
	elif  left_side_3.is_colliding() and collision_layer==10:
		right_canon.look_at(Player_direction)
	elif  right_side_2.is_colliding() and collision_layer ==10:
		left_canon.look_at(Player_direction)
	elif  right_side_3.is_colliding() and collision_layer ==10:
		left_canon.look_at(Player_direction)
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
		
		if  ray_cast_2d_4.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  ray_cast_2d_5.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  ray_cast_2d_6.is_colliding() and collision_layer ==10:
			shoot_up()	
		elif  right_side.is_colliding() and collision_layer ==10:
			
			shoot_left()
		elif  left_side.is_colliding() and collision_layer ==10:
			shoot_right()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D :
		var explosion_center = global_position
		var direction_to_body = (body.global_position - explosion_center).normalized()
		
		# Define the strength of the explosion
		var explosion_force = 500.0  # Adjust this value as needed
		
		# Apply force to push the body away
		body.velocity += direction_to_body * explosion_force
