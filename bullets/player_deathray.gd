extends Area2D

@export var damage: int = 1
@onready var line_2d = $Line2D
@onready var col = $CollisionShape2D

var is_firing = false

func _ready() -> void:
	line_2d.width = 0
	col.disabled = true
	
	# Set up the visual line
	line_2d.clear_points()
	line_2d.add_point(Vector2(0, 0))
	line_2d.add_point(Vector2(2000, 0)) # Beam reaches 2000 pixels forward
	line_2d.default_color = Color(0.0, 0.5, 1.0, 0.0) # Transparent blue
	
	# Make the beam triangular using a width curve
	var curve = Curve.new()
	curve.add_point(Vector2(0.0, 0.0)) # Starts thin at the gun
	curve.add_point(Vector2(1.0, 1.0)) # Expands wide at the end
	line_2d.width_curve = curve
	
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	line_2d.material = mat
	
	# Start firing immediately since it's a powerup
	fire_beam()

func fire_beam():
	# Charge up fast
	var tween1 = create_tween()
	tween1.tween_property(line_2d, "width", 4.0, 0.2)
	tween1.parallel().tween_property(line_2d, "default_color", Color(0.6, 0.8, 1.0, 0.6), 0.2)
	await get_tree().create_timer(0.2).timeout
	if not is_inside_tree(): return
	
	# Fire!
	is_firing = true
	col.set_deferred("disabled", false)
	
	var tween2 = create_tween()
	tween2.tween_property(line_2d, "width", 500.0, 0.1) # Max width of the cone base
	tween2.parallel().tween_property(line_2d, "default_color", Color(0.0, 0.5, 1.0, 1.0), 0.1)
	
	# Keep firing for 3 seconds
	await get_tree().create_timer(3.0).timeout
	if not is_inside_tree(): return
	
	# Fade out
	is_firing = false
	col.set_deferred("disabled", true)
	
	var tween3 = create_tween()
	tween3.tween_property(line_2d, "width", 0.0, 0.4)
	tween3.parallel().tween_property(line_2d, "default_color", Color(0.0, 0.5, 1.0, 0.0), 0.4)
	
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_damage_timer_timeout() -> void:
	if is_firing:
		for body in get_overlapping_bodies():
			_apply_damage(body)

func _on_body_entered(body: Node2D) -> void:
	if is_firing:
		_apply_damage(body)

func _apply_damage(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		if body.has_method("kill"):
			body.kill()
