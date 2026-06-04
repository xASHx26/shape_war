extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var deathPrticle:PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var turret: Node2D = $Turret

@export var rotation_speed = 10.0 
@export var health: int = 2
var follow:=false

		
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false and player:
		var direction =global_position.direction_to(player.global_position)
		velocity=direction*speed*delta
		
		if turret:
			turret.look_at(player.global_position)
		
		move_and_slide()
		

func take_damage(amount: int) -> void:
	health -= amount
	if animation_player:
		animation_player.play("damage")

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
	get_parent().add_child(new_bullet)

func _on_timer_timeout() -> void:
	if Global.curr_health>0 and player:
		if global_position.distance_to(player.global_position) < 900:
			shoot()
