extends Node2D

@onready var enemy_1_timer: Timer = $enemy1_timer
@onready var enemy_2_timer: Timer = $enemy2_timer
@onready var spaceship_spwaner: Marker2D = $spaceship_spwaner
@export var player:Array[PackedScene]
@onready var timer: Timer = $Timer
@onready var _3_rdenemy: Timer = $'3rdenemy'
@export var spcaeNumber:int=0
var range_score=randi_range(10,15)
var enemy1_def:int=range_score
var enemy2_def:int
var enemy3_def:int
var next_threshold = 50  # Start with the first threshold at 50 points
var player_spawned = false
var player2_spawn :=false
var player1_spawn :=false

var spawn3_called = false  # Track if spawn3 has been called

func _ready() -> void:
	Global.count =46
func _process(delta: float) -> void:
	
	player_spawner(1)
	deff_manager()
	printt(enemy_1_timer.wait_time,enemy_2_timer.wait_time,_3_rdenemy.wait_time,_3_rdenemy.time_left,next_threshold)
func spawn()->void:
	
		var new_enemy1=preload('res://enemys/enemy_1.tscn').instantiate()
		%PathFollow2D.progress_ratio=randf()
		new_enemy1.global_position=%PathFollow2D.global_position
		player1_spawn=true
		add_child(new_enemy1)
	
func player_spawner(n:int)->void:
	if not player_spawned:
		var new_space = player[n].instantiate()
		new_space.global_position = spaceship_spwaner.global_position
		add_child(new_space)
		player_spawned = true
func spawn2()->void:
	
		var new_enemy1=preload('res://enemys/enemy_2.tscn').instantiate()
		%PathFollow2D.progress_ratio=randf()
		new_enemy1.global_position=%PathFollow2D.global_position
		player2_spawn=true
		add_child(new_enemy1)
func spawn3() -> void:
	if Global.count>=40:
		
		if not spawn3_called:
			var new_enemy3 = preload("res://enemys/enemy_paths.tscn").instantiate()
			add_child(new_enemy3)
			Global.total_enemy3 += 1
			spawn3_called = true  # Mark as called to prevent immediate re-trigger
	


func deff_manager() -> void:
	
	# Check if the global score has reached the next threshold
	if Global.count >= next_threshold:
		# Reduce enemy timers with a minimum limit to avoid excessive speed
		enemy_1_timer.wait_time = max(enemy_1_timer.wait_time - 0.5, 1.0)
		enemy_2_timer.wait_time = max(enemy_2_timer.wait_time - 0.5, 2.0)
		_3_rdenemy.wait_time = max(_3_rdenemy.wait_time - 5, 10.0)

		# Update the next threshold to 50 points ahead
		next_threshold += 50

	
func enemy1_deff():
	
	spawn()
	Global.total_enemy1+=1
	
	
func enemy2_deff():
	if Global.count>=15:
		spawn2()
		Global.total_enemy2+=1
	


func enemy3_deff():
	
		
	if Global.count >= 40  :
		spawn3() 
		Global.total_enemy3+=1 # Call spawn3 only once when conditions are met
		
	
	
		
		
func _on_timer_timeout() -> void:
	enemy1_deff()
	


func _on_enemy_2_timer_timeout() -> void:
	enemy2_deff()
	
	

func _on_rdenemy_timeout() -> void:

	spawn3_called=false
	spawn3()
