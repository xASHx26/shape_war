extends CharacterBody2D

@export var rotation_speed = 5.0
@export var speed = 4000
@export var dead_zone_threshold = 0.1  # Small angle in radians to define the dead zone

@onready var player = get_node("/root/main/spaceship/rocket/rotation")
@onready var marker_2d: Marker2D = $Marker2D

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
	else:
		# Reload the current scene if health is depleted
		get_tree().reload_current_scene()

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
		Global.total_enemy1-=1
		queue_free()
	
