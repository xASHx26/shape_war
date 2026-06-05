extends Area2D

func _ready():
	# Draw aura
	var points = PackedVector2Array()
	var segments = 32
	var radius = 250.0
	for i in range(segments + 1):
		var angle = i * TAU / segments
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	$Line2D.points = points
	$Line2D.width = 15.0
	$Line2D.default_color = Color(0.0, 1.0, 1.0, 0.8)
	
	# Initial inner kill check
	await get_tree().physics_frame # wait for physics to update overlaps
	for body in $DeathArea.get_overlapping_bodies():
		_process_body_damage(body)
	
	# Lifecycle
	await get_tree().create_timer(3.0).timeout
	var blink_timer = 0.0
	while blink_timer < 2.0 and is_inside_tree():
		$Line2D.visible = !$Line2D.visible
		await get_tree().create_timer(0.2).timeout
		blink_timer += 0.2
	
	queue_free()

func _process_body_damage(body: Node2D):
	if body.is_in_group("enemy1") or body.is_in_group("enemy2") or body.is_in_group("enemy5"):
		if body.has_method("take_damage"):
			body.take_damage(999) # Instakill
		elif body.has_method("kill"):
			body.kill()

func _on_death_area_body_entered(body: Node2D):
	_process_body_damage(body)

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy1") or body.is_in_group("enemy2") or body.is_in_group("enemy5"):
		# They hit the outer shield, bounce them far away!
		var push_dir = global_position.direction_to(body.global_position)
		if push_dir == Vector2.ZERO: push_dir = Vector2.RIGHT
		
		# Teleport them to a radius of 600, acting like a violent bounce
		var tween = create_tween()
		var target_pos = global_position + push_dir * 600.0
		# Fast tween so it looks like a physical knockback rather than teleport
		tween.tween_property(body, "global_position", target_pos, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
