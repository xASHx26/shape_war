extends Node2D

@export var jumps: int = 5
@export var damage: int = 999
@export var max_jump_distance: float = 600.0

@onready var line: Line2D = $Line2D

var current_target: Node2D = null
var targets_hit = []

func _ready():
	# Start at player
	var player = get_tree().get_first_node_in_group("spaceship")
	if not player:
		queue_free()
		return
		
	global_position = player.global_position
	line.add_point(Vector2.ZERO)
	
	current_target = player
	
	# Jump loop
	for i in range(jumps):
		var next_target = get_next_target(current_target.global_position)
		if next_target:
			targets_hit.append(next_target)
			line.add_point(to_local(next_target.global_position))
			
			if next_target.has_method("kill"):
				next_target.health = 0
				next_target.kill()
			elif next_target.has_method("take_damage"):
				next_target.take_damage(damage)
				
			current_target = next_target
		else:
			break
			
	# Fade out
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func get_next_target(pos: Vector2) -> Node2D:
	var closest = null
	var closest_dist = max_jump_distance
	
	for group_name in ["enemy1", "enemy2", "enemy3"]:
		for enemy in get_tree().get_nodes_in_group(group_name):
			if not is_instance_valid(enemy): continue
			if enemy in targets_hit: continue
			
			var dist = pos.distance_to(enemy.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = enemy
				
	return closest
