extends Node2D

@export var orbit_speed: float = 2.0
@export var orbit_radius: float = 120.0
@export var fire_rate: float = 0.5
@export var detection_radius: float = 800.0

var angle: float = 0.0
var player: Node2D = null

@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	timer.wait_time = fire_rate
	timer.start()

func _process(delta):
	if is_instance_valid(player):
		angle += orbit_speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * orbit_radius
		global_position = player.global_position + offset
		
		# Look at closest enemy
		var target = get_closest_enemy()
		if target:
			sprite.look_at(target.global_position)
		else:
			sprite.rotation = angle + PI/2

func get_closest_enemy() -> Node2D:
	var closest = null
	var closest_dist = detection_radius
	
	for group_name in ["enemy1", "enemy2", "enemy3"]:
		for enemy in get_tree().get_nodes_in_group(group_name):
			if not is_instance_valid(enemy): continue
			var dist = global_position.distance_to(enemy.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy
				
	return closest

func _on_timer_timeout():
	var target = get_closest_enemy()
	if target:
		shoot(target.global_position)

func shoot(target_pos: Vector2):
	var bullet_scene = load("res://bullets/player_bullet.tscn")
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.global_rotation = global_position.angle_to_point(target_pos)
		get_tree().current_scene.add_child(bullet)
