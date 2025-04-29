extends CharacterBody2D

@export var rotation_speed = 5.0
@export var speed = 4000
@export var dead_zone_threshold = 0.1 
<<<<<<< HEAD
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
=======
<<<<<<< HEAD
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e

@export var deathPrticle:PackedScene
@onready var player = get_node("/root/main/spaceship/rocket/rotation")
@onready var marker_2d: Marker2D = $Marker2D
var health:=1
func  _process(delta: float) -> void:
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
	if Global.curr_health > 0:
		# Calculate direction vector from the rocket to the player's position
		var direction = global_position.direction_to(player.global_position)

		# Get the angle of the direction vector
		var target_angle = direction.angle()

		# Check if the angle difference is greater than the dead zone threshold
		if abs(target_angle - rotation) > dead_zone_threshold:
			# Smoothly interpolate the rocket's rotation towards the target angle
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

		# Move the rocket towards the player's position
		velocity = direction * speed*delta	
		move_and_slide()
	
func kill():
	if health<=0:
		Global.count += 1
<<<<<<< HEAD
		SaveGame.data["Points"]+=1
		SaveGame.Write_save(SaveGame.data)
=======
<<<<<<< HEAD
		SaveGame.data["Points"]+=1
		SaveGame.Write_save(SaveGame.data)
=======
<<<<<<< HEAD
		SaveGame.data["Points"]+=1
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
	explosion.global_position = global_position  # Set explosion position
	explosion.emitting = true
func increase_speed():
	speed = 8000  # Increase speed when called

# Handle collision with player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spaceship"):
		queue_free()

# Handle collision with other areas
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spaceship"):
		Global.curr_health-=2
		health-=1
		
	
