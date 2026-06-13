extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@export_range(0.0, 1.0) var powerup_drop_chance: float = 1.0
@export var deathPrticle:PackedScene
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var turret: Node2D = $Turret

@export var rotation_speed = 10.0 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var follow:=false

@export var health: int = 3		
func _ready() -> void:
	# Attach the continuous death ray to the turret
	var death_ray = preload("res://bullets/enemy3_deathray.tscn").instantiate()
	%shotting_point_enemy.add_child(death_ray)
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false and player:
		if Global.is_time_frozen: return
		if turret:
			# Smoothly interpolate the rotation so the death ray "sweeps" across the screen
			var target_angle = turret.global_position.angle_to_point(player.global_position)
			turret.global_rotation = lerp_angle(turret.global_rotation, target_angle, delta * 1.5)
	
func take_damage(amount: int) -> void:
	health -= amount

func kill():
	if health<=0:
		Global.count += 5
		SaveGame.data["Points"]+=5
		SaveGame.Write_save(SaveGame.data)
		explo()
		
		# Drop a random Tier 3 powerup
		if randf() <= powerup_drop_chance:
			var powerup_scene = load("res://powerups/powerup.tscn")
			if powerup_scene:
				var powerup = powerup_scene.instantiate()
				powerup.global_position = global_position
				powerup.type = [5, 6, 8].pick_random() # Tier 3: Black Hole, Chrono Shift, EMP (Nuke)
				get_tree().current_scene.call_deferred("add_child", powerup)
				
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
	
	speed=100


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D :
		var explosion_center = global_position
		var direction_to_body = (body.global_position - explosion_center).normalized()
		
		# Define the strength of the explosion
		var explosion_force = 500.0  # Adjust this value as needed
		
		# Apply force to push the body away
		body.velocity += direction_to_body * explosion_force
