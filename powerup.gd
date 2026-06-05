extends Area2D

enum PowerupType { HEALTH, SPEED, RAPID_FIRE_360, SHIELD, DEATH_BEAM }
@export var type: PowerupType = PowerupType.HEALTH

var fall_speed = 100.0
var attract_speed = 60.0
var player = null

func _ready():
	if type == PowerupType.HEALTH:
		$Sprite2D.texture = load("res://SPRITE/health_powerup.png")
	elif type == PowerupType.SPEED:
		$Sprite2D.texture = load("res://SPRITE/speed_powerup.png")
	elif type == PowerupType.RAPID_FIRE_360:
		$Sprite2D.texture = load("res://SPRITE/AI/icon_rapid_fire.png")
	elif type == PowerupType.SHIELD:
		$Sprite2D.texture = load("res://SPRITE/AI/icon_shield.png")
	elif type == PowerupType.DEATH_BEAM:
		$Sprite2D.texture = load("res://SPRITE/AI/icon_death_beam.png")
		
	player = get_tree().get_first_node_in_group("spaceship")

func _process(delta):
	var velocity = Vector2(0, fall_speed)
	
	if is_instance_valid(player):
		var direction = global_position.direction_to(player.global_position)
		velocity += direction * attract_speed
		
	position += velocity * delta
	
	if position.y > 800:
		queue_free()

func apply_powerup(target: Node2D):
	# Apply a color flash effect to the player to indicate powerup collection
	var tween = get_tree().create_tween()
	var flash_color = Color(0, 1, 0) # Green for health
	
	if type == PowerupType.HEALTH:
		Global.curr_health = min(Global.curr_health + 2, Global.max_heath)
	elif type == PowerupType.SPEED:
		flash_color = Color(0, 0.5, 1) # Blue for speed
		if target.has_method("apply_speed_buff"):
			target.apply_speed_buff()
	elif type == PowerupType.RAPID_FIRE_360:
		flash_color = Color(1.0, 1.0, 0.0) # Yellow for rapid fire
		if target.has_method("apply_rapid_fire_360"):
			target.apply_rapid_fire_360()
	elif type == PowerupType.SHIELD:
		flash_color = Color(0.0, 1.0, 1.0) # Cyan for shield
		if target.has_method("apply_shield"):
			target.apply_shield()
	elif type == PowerupType.DEATH_BEAM:
		flash_color = Color(1.0, 0.0, 0.0) # Red for death beam
		if target.has_method("apply_death_beam"):
			target.apply_death_beam()
			
	# Animate the player's color
	if target is CharacterBody2D:
		target.modulate = flash_color
		tween.tween_property(target, "modulate", Color(1, 1, 1), 0.5)
	elif target.get_parent() is CharacterBody2D:
		target.get_parent().modulate = flash_color
		tween.tween_property(target.get_parent(), "modulate", Color(1, 1, 1), 0.5)
		
	queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("spaceship"):
		apply_powerup(body)

func _on_area_entered(area: Area2D):
	if area.is_in_group("spaceship"):
		apply_powerup(area.get_parent())
