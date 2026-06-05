extends Area2D

@export var damage: int = 1
@onready var line_2d = $Line2D
@onready var col = $CollisionShape2D
@onready var charge_sparks = $ChargeSparks

var is_firing = false

func _ready() -> void:
	line_2d.width = 0
	col.disabled = true
	
	# Set up the visual line
	line_2d.clear_points()
	line_2d.add_point(Vector2(0, 0))
	line_2d.add_point(Vector2(3000, 0)) # Beam reaches 3000 pixels forward
	line_2d.default_color = Color(1.0, 0.1, 0.1, 0.0)
	
	# Make the beam triangular using a width curve!
	var curve = Curve.new()
	curve.add_point(Vector2(0.0, 0.0)) # Starts thin at the gun
	curve.add_point(Vector2(1.0, 1.0)) # Expands wide at the end
	line_2d.width_curve = curve
	
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	line_2d.material = mat
	
	# Start cycle
	fire_cycle()

func fire_cycle():
	while is_inside_tree():
		# Cooldown
		is_firing = false
		col.set_deferred("disabled", true)
		await get_tree().create_timer(3.0).timeout
		if not is_inside_tree(): break
		
		# Charge up (Warning line)
		charge_sparks.emitting = true
		var tween1 = create_tween()
		tween1.tween_property(line_2d, "width", 4.0, 1.5)
		tween1.parallel().tween_property(line_2d, "default_color", Color(1.0, 0.8, 0.8, 0.6), 1.5)
		await get_tree().create_timer(1.5).timeout
		if not is_inside_tree(): break
		
		# Fire
		charge_sparks.emitting = false
		is_firing = true
		col.set_deferred("disabled", false)
		
		var tween2 = create_tween()
		tween2.tween_property(line_2d, "width", 500.0, 0.1)
		tween2.parallel().tween_property(line_2d, "default_color", Color(1.0, 0.0, 0.0, 1.0), 0.1)
		await get_tree().create_timer(1.5).timeout
		if not is_inside_tree(): break
		
		# Fade out
		is_firing = false
		col.set_deferred("disabled", true)
		
		var tween3 = create_tween()
		tween3.tween_property(line_2d, "width", 0.0, 0.4)
		tween3.parallel().tween_property(line_2d, "default_color", Color(1.0, 0.0, 0.0, 0.0), 0.4)

func _on_damage_timer_timeout() -> void:
	if is_firing:
		for body in get_overlapping_bodies():
			_apply_damage(body)

func _on_body_entered(body: Node2D) -> void:
	if is_firing:
		_apply_damage(body)

func _apply_damage(body: Node2D) -> void:
	if body.is_in_group("spaceship"):
		Global.curr_health -= damage
	elif not body.is_in_group("enemy3") and body.has_method("take_damage"):
		# Damage other enemies, but not Enemy 3 (itself) or Enemy 4
		body.take_damage(damage)
		if body.has_method("kill"):
			body.kill()
