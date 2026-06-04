extends Path2D
@onready var path_follow_2d: PathFollow2D = $PathFollow2D


@export var speed = 0.01
@export var enemy: PackedScene
var current_enemy: Node2D = null
@onready var timer: Timer = $Timer

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
func spawn() -> void:
	var new_enemy = enemy.instantiate()
	
	# Add the enemy as a child of the PathFollow2D to follow the path
	path_follow_2d.add_child(new_enemy)
	
	# Set enemy position to start at the beginning of the path
	new_enemy.position = Vector2.ZERO
	current_enemy = new_enemy
	
	# Listen for when the enemy is destroyed
	new_enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	path_follow_2d.progress_ratio = 0
	current_enemy = null
	timer.start()



func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio=0
	spawn()
