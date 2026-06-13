extends CharacterBody2D

@onready var player = get_node("/root/main/spaceship/rocket")
@export var speed = 3500
@export var health: int = 4
@export var powerup_drop_chance: float = 0.5

@onready var left_gun = $LeftGun
@onready var right_gun = $RightGun
@onready var timer = $Timer

var follow := false

func _ready() -> void:
	timer.wait_time = 3.0 # Fires dual helix every 3 seconds

func _physics_process(delta: float) -> void:
	if Global.curr_health > 0 and follow == false and player:
		var current_speed = speed
		if Global.is_time_frozen:
			current_speed = 0.0
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * current_speed * delta
		
		# Rotate UFO smoothly towards player
		var target_angle = global_position.angle_to_point(player.global_position)
		rotation = lerp_angle(rotation, target_angle, delta * 3.0)
		
		move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount

func kill():
	if health <= 0:
		Global.count += 5
		SaveGame.data["Points"] += 5
		SaveGame.Write_save(SaveGame.data)
		
		if randf() <= powerup_drop_chance:
			var powerup_scene = load("res://powerups/powerup.tscn")
			if powerup_scene:
				var powerup = powerup_scene.instantiate()
				powerup.global_position = global_position
				powerup.type = (randi() % 3) + 2
				get_tree().current_scene.call_deferred("add_child", powerup)
				
		queue_free()

func _process(delta: float) -> void:
	if Global.curr_health <= 0:
		set_process(false) 
	kill()

func shoot():
	var bullet_scene = preload("res://bullets/enemy2_dagger.tscn")
	
	# Fire from Left Gun
	var left_bullet = bullet_scene.instantiate()
	left_bullet.global_position = left_gun.global_position
	left_bullet.global_rotation = global_rotation
	get_parent().add_child(left_bullet)
	
	# Fire from Right Gun
	var right_bullet = bullet_scene.instantiate()
	right_bullet.global_position = right_gun.global_position
	right_bullet.global_rotation = global_rotation
	get_parent().add_child(right_bullet)

func _on_timer_timeout() -> void:
	if Global.curr_health > 0 and player and not Global.is_time_frozen:
		if global_position.distance_to(player.global_position) < 1500:
			shoot()
