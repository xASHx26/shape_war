extends CharacterBody2D
@onready var player=get_node("/root/main/spaceship/rocket")
@export var speed=4000
@export_range(0.0, 1.0) var powerup_drop_chance: float = 1.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var deathPrticle:PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var turret: Node2D = $Turret

@export var rotation_speed = 10.0 
@export var health: int = 2
var follow:=false

		
func _ready() -> void:
	$Timer.wait_time = 2.0
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		animated_sprite_2d.stop()
		set_process(false) 
	kill()
func _physics_process(delta: float) -> void:
	if Global.curr_health>0 and follow==false and player:
		var current_speed = speed
		if Global.is_time_frozen:
			current_speed = 0.0
		var direction =global_position.direction_to(player.global_position)
		velocity=direction*current_speed*delta
		
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
		
		# Drop a powerup based on probability
		if randf() <= powerup_drop_chance:
			var powerup_scene = load("res://powerups/powerup.tscn")
			if powerup_scene:
				var powerup = powerup_scene.instantiate()
				powerup.global_position = global_position
				powerup.type = (randi() % 2) + 3 # Tier 2: Shield, Death Beam
				get_tree().current_scene.call_deferred("add_child", powerup)
				
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
	var new_bullet=preload('res://bullets/enemy2_comet.tscn').instantiate()
	new_bullet.global_position=%shotting_point_enemy.global_position
	new_bullet.global_rotation=%shotting_point_enemy.global_rotation
	get_parent().add_child(new_bullet)

func _on_timer_timeout() -> void:
	if Global.curr_health>0 and player and not Global.is_time_frozen:
		if global_position.distance_to(player.global_position) < 900:
			shoot()
