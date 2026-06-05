extends Area2D

@export var speed: float = 650.0
@export var frequency: float = 12.0
@export var amplitude: float = 60.0
@export var damage: int = 2

var time: float = 0.0

@onready var dagger1 = $Dagger1
@onready var col1 = $Dagger1Col
@onready var dagger2 = $Dagger2
@onready var col2 = $Dagger2Col

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	var offset = sin(time * frequency) * amplitude
	
	if is_instance_valid(dagger1) and is_instance_valid(col1):
		dagger1.position.y = offset
		col1.position.y = offset
		# Rotate slightly to face the angle of movement
		var angle = cos(time * frequency) * amplitude * frequency / speed
		dagger1.rotation = angle
		col1.rotation = angle
	
	if is_instance_valid(dagger2) and is_instance_valid(col2):
		dagger2.position.y = -offset
		col2.position.y = -offset
		var angle2 = -cos(time * frequency) * amplitude * frequency / speed
		dagger2.rotation = angle2
		col2.rotation = angle2
	
	# Move forward
	position += transform.x * speed * delta
	
	# Clean up if offscreen
	if position.x < -1000 or position.x > 3000 or position.y < -1000 or position.y > 2000:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("spaceship"):
		Global.curr_health -= damage
		queue_free()
