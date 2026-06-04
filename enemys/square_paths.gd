extends Path2D
@onready var path_follow_2d: PathFollow2D = $PathFollow2D


@export var speed = 0.01
@export var enemy: PackedScene

func _ready() -> void:
	# Spawn the enemy and make it follow the path
	path_follow_2d.progress_ratio=0

func _process(delta: float) -> void:
	# Move the path follower along the path
	path_follow_2d.progress_ratio += delta * speed
	if Global.curr_health<=0:
		set_process(false) 
	# Wrap the progress_ratio if it exceeds 1 (for continuous looping)
	if path_follow_2d.progress_ratio >= 1:
		path_follow_2d.progress_ratio = 0.2155
	if enemy.is_queued_for_deletion():
		path_follow_2d.progress_ratio=0
func spawn() -> void:
	var new_enemy = enemy.instantiate()
	
	# Add the enemy as a child of the PathFollow2D to follow the path
	path_follow_2d.add_child(new_enemy)
	
	# Set enemy position to start at the beginning of the path
	new_enemy.position = Vector2.ZERO



func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio=0
	spawn()
