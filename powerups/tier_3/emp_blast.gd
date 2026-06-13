extends Area2D

@export var max_radius: float = 1200.0
@export var expand_duration: float = 0.5

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect

func _ready():
	# Start tiny
	scale = Vector2(0.1, 0.1)
	
	# Play explosion sound if available
	# ...
	
	# Tween the expansion
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(max_radius / 100.0, max_radius / 100.0), expand_duration)
	
	# Fade out at the end
	tween.parallel().tween_property(color_rect, "modulate:a", 0.0, expand_duration)
	tween.tween_callback(queue_free)

func _on_body_entered(body):
	if body.is_in_group("enemy1") or body.is_in_group("enemy2") or body.is_in_group("enemy3") or body.is_in_group("enemy5"):
		if body.has_method("kill"):
			body.health = 0
			body.kill()
		elif body.has_method("take_damage"):
			body.take_damage(9999)

func _on_area_entered(area):
	# Destroy enemy bullets and hazards
	var n_name = area.name.to_lower()
	if "bullet" in n_name or "dagger" in n_name or "ray" in n_name or "enemy4" in n_name:
		area.queue_free()
	elif area.get_script() != null:
		var s_path = area.get_script().resource_path.to_lower()
		if "bullet" in s_path or "dagger" in s_path or "ray" in s_path or "enemy4" in s_path:
			area.queue_free()
