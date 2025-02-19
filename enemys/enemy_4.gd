extends Area2D

@onready var first: MeshInstance2D = $first
@onready var first_c: CollisionShape2D = $first_C
@onready var _2_nd: MeshInstance2D = $'2nd'
@onready var _2_nd_c: CollisionShape2D = $'2nd_C'
@onready var _3_rd: MeshInstance2D = $'3rd'
@onready var _3_rd_c: CollisionShape2D = $'3rd_c'
@onready var _4_th: MeshInstance2D = $'4th'
@onready var _4_th_c: CollisionShape2D = $'4th_c'
@export var speed := 500

var active_objects = []
var traveled_distances = {
	"first": 0.0,
	"second": 0.0,
	"third": 0.0,
	"fourth": 0.0
}
var distance_limit = 4000  # Distance at which objects will be removed

func _physics_process(delta: float) -> void:
	move_objects(delta)
	
func move_objects(delta: float) -> void:
	# Create a temporary list to store objects that should be removed
	var objects_to_remove = []
	for obj in active_objects:
		match obj:
			"first":
				# Check if the object still exists
				if is_instance_valid(first) and is_instance_valid(first_c):
					first.position.x -= speed * delta
					first_c.position.x -= speed * delta
					traveled_distances["first"] += speed * delta
					if traveled_distances["first"] > distance_limit:
						first.queue_free()
						first_c.queue_free()
						objects_to_remove.append("first")
			"second":
				if is_instance_valid(_2_nd) and is_instance_valid(_2_nd_c):
					_2_nd.position.x -= speed * delta
					_2_nd_c.position.x -= speed * delta
					traveled_distances["second"] += speed * delta
					if traveled_distances["second"] > distance_limit:
						_2_nd.queue_free()
						_2_nd_c.queue_free()
						objects_to_remove.append("second")
			"third":
				if is_instance_valid(_3_rd) and is_instance_valid(_3_rd_c):
					_3_rd.position.x -= speed * delta
					_3_rd_c.position.x -= speed * delta
					traveled_distances["third"] += speed * delta
					if traveled_distances["third"] > distance_limit:
						_3_rd.queue_free()
						_3_rd_c.queue_free()
						objects_to_remove.append("third")
			"fourth":
				if is_instance_valid(_4_th) and is_instance_valid(_4_th_c):
					_4_th.position.x -= speed * delta
					_4_th_c.position.x -= speed * delta
					traveled_distances["fourth"] += speed * delta
					if traveled_distances["fourth"] > distance_limit:
						_4_th.queue_free()
						_4_th_c.queue_free()
						objects_to_remove.append("fourth")

	# Remove objects from active_objects after looping
	for obj in objects_to_remove:
		active_objects.erase(obj)

func _on_timer_timeout() -> void:
	var move = randi_range(0, 10)
	
	if move >= 3 and move < 7:
		if "first" not in active_objects:
			active_objects.append("first")
		if "second" not in active_objects:
			active_objects.append("second")
	elif move >= 7 and move <= 10:
		if "third" not in active_objects:
			active_objects.append("third")
		if "fourth" not in active_objects:
			active_objects.append("fourth")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("spaceship"):
		Global.curr_health -= 5
	elif body.is_in_group("enemy1") or body.is_in_group("enemy2") or body.is_in_group("enemy3"):
		body.queue_free()
