extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1

@onready var tail = $Tail
var trail_length = 15

func _ready() -> void:
	tail.set_as_top_level(true) # Detach transform
	tail.global_position = Vector2.ZERO # CRITICAL: Reset origin so global points render correctly!
	tail.clear_points()

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	position += transform.x * speed * delta
	
	# Add a swinging offset based on time so the tail wiggles wildly
	var swing_offset = transform.y * sin(time * 30.0) * 20.0
	
	# Update the trail line
	tail.add_point(global_position + swing_offset)
	if tail.get_point_count() > trail_length:
		tail.remove_point(0)
	
	if position.x < -1000 or position.x > 3000 or position.y < -1000 or position.y > 2000:
		tail.queue_free()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("spaceship"):
		Global.curr_health -= damage
		tail.queue_free()
		queue_free()
