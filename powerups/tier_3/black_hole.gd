extends Area2D

@export var pull_strength: float = 300.0
@export var damage_per_tick: int = 1
@export var lifetime: float = 8.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var damage_timer: Timer = $DamageTimer

var active: bool = false

func _ready():
	scale = Vector2.ZERO
	# Spawn animation (scale up)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): active = true)
	
	# Start damage timer
	damage_timer.wait_time = 0.5
	damage_timer.start()
	
	# Setup destruction
	get_tree().create_timer(lifetime).timeout.connect(_on_lifetime_end)

func is_enemy(node: Node) -> bool:
	if not node: return false
	for g in node.get_groups():
		if str(g).begins_with("enemy"):
			return true
	return false

func _process(delta):
	sprite.rotation += delta * 2.0
	
	if not active:
		return
		
	var enemies = get_overlapping_areas() + get_overlapping_bodies()
	for enemy in enemies:
		var target_enemy = enemy
		if not is_enemy(target_enemy) and target_enemy.get_parent() and is_enemy(target_enemy.get_parent()):
			target_enemy = target_enemy.get_parent()
			
		if is_enemy(target_enemy):
			
			# Pull enemy towards the center
			var direction = global_position - target_enemy.global_position
			var distance = direction.length()
			
			if distance > 10.0:
				# Override enemy velocity to pull them in
				if target_enemy is CharacterBody2D:
					target_enemy.velocity = direction.normalized() * pull_strength
					target_enemy.move_and_slide()
				else:
					target_enemy.global_position += direction.normalized() * pull_strength * delta
					
				# Shrink effect
				target_enemy.scale = target_enemy.scale.lerp(Vector2.ZERO, delta * 2.0)
			else:
				# Reached the center, take massive damage instantly or just let it shrink to nothing
				if target_enemy.has_method("take_damage"):
					target_enemy.take_damage(999)

func _on_damage_timer_timeout():
	if not active: return
	
	var enemies = get_overlapping_areas() + get_overlapping_bodies()
	for enemy in enemies:
		var target_enemy = enemy
		if not is_enemy(target_enemy) and target_enemy.get_parent() and is_enemy(target_enemy.get_parent()):
			target_enemy = target_enemy.get_parent()
			
		if is_enemy(target_enemy):
			if target_enemy.has_method("take_damage"):
				target_enemy.take_damage(damage_per_tick)

func _on_lifetime_end():
	active = false
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
