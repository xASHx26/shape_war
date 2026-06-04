extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@export var deathPrticle:PackedScene
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var turret: Node2D = $Turret

@export var rotation_speed = 10.0 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var follow:=false

@export var health: int = 3		
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false and player:
		if turret:
			turret.look_at(player.global_position)
	
func take_damage(amount: int) -> void:
	health -= amount

func kill():
	if health<=0:
		Global.count += 5
		SaveGame.data["Points"]+=5
		SaveGame.Write_save(SaveGame.data)
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
	
func shoot():
	var new_bullet = preload('res://bullets/enemy2_bullets.tscn').instantiate()
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = %shotting_point_enemy.global_position
	new_bullet.global_rotation = %shotting_point_enemy.global_rotation

func _on_timer_timeout() -> void:
	if Global.curr_health>0 and player:
		if global_position.distance_to(player.global_position) < 1200:
			shoot()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D :
		var explosion_center = global_position
		var direction_to_body = (body.global_position - explosion_center).normalized()
		
		# Define the strength of the explosion
		var explosion_force = 500.0  # Adjust this value as needed
		
		# Apply force to push the body away
		body.velocity += direction_to_body * explosion_force
