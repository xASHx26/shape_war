extends Node2D
func _process(delta: float) -> void:
	pass
@onready var enemy_1_timer: Timer = $enemy1_timer
@onready var enemy_2_timer: Timer = $enemy2_timer
	
@onready var timer: Timer = $Timer

func spawn()->void:
	var new_enemy1=preload('res://enemys/enemy_1.tscn').instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_enemy1.global_position=%PathFollow2D.global_position
	
	add_child(new_enemy1)
func spawn2()->void:
	var new_enemy1=preload('res://enemys/enemy_2.tscn').instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_enemy1.global_position=%PathFollow2D.global_position
	
	add_child(new_enemy1)

func _on_timer_timeout() -> void:
	if Global.count>=10:
		enemy_1_timer.wait_time=4
		spawn()
	else :
		spawn()
		
	


func _on_enemy_2_timer_timeout() -> void:
	if Global.count>=10:
		spawn2()
