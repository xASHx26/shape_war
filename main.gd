extends Node2D

@onready var enemy_1_timer: Timer = $enemy1_timer
@onready var enemy_2_timer: Timer = $enemy2_timer
@onready var spaceship_spwaner: Marker2D = $spaceship_spwaner
@export var player:Array[PackedScene]
@onready var timer: Timer = $Timer
@onready var _3_rdenemy: Timer = $'3rdenemy'
@onready var enemy_4_timer: Timer = $enemy4_timer
@onready var enemy_4_marker: Marker2D = $enemy4_marker
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
@onready var Player_health: TextureProgressBar = $TextureProgressBar
@onready var warning: AnimationPlayer = $AnimationPlayer
@onready var end_game: CanvasLayer = $End_game

<<<<<<< HEAD
=======
=======
<<<<<<< HEAD
@onready var Player_health: TextureProgressBar = $TextureProgressBar
@onready var warning: AnimationPlayer = $AnimationPlayer
=======
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e




var range_score=randi_range(10,15)
var enemy1_def:int=range_score
var enemy2_def:int
var enemy3_def:int
var next_threshold = 50  
var player_spawned = false
var player2_spawn :=false
var player1_spawn :=false

var spawn3_called = false 
var spawn4_called = false 
var spcaeNumber = 0  # Default value, will be replaced after loading

func _ready() -> void:
<<<<<<< HEAD
	print(OS.get_data_dir())
	
	Global.curr_health=10
	print(SaveGame.data["Points"])
	var save_data = SaveGame.read_save()  # Read save data from JSON
	if save_data:
		SaveGame.data = save_data  # Store the data globally
		spcaeNumber = SaveGame.data.get("player_ship", 1)  # Get saved value
	
	
=======
<<<<<<< HEAD
	end_game.visible=false
	print(SaveGame.data["Points"])
=======
<<<<<<< HEAD
	print(SaveGame.data["Points"])
=======
	
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
	var save_data = SaveGame.read_save()  # Read save data from JSON
	if save_data:
		SaveGame.data = save_data  # Store the data globally
		spcaeNumber = SaveGame.data.get("player_ship", 0)  # Get saved value
<<<<<<< HEAD
	
=======
<<<<<<< HEAD
	
=======

>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9

>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	player_spawner(spcaeNumber)  # Spawn the correct ship based on saved data

	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"change"):  # Ensures it triggers once per press
		if SaveGame.data["player_ship"] ==1:
			SaveGame.data["player_ship"] = 0  # Change the value in-memory
			SaveGame.Write_save(SaveGame.data)  # Save to JSON file
			get_tree().reload_current_scene()	
		elif SaveGame.data["player_ship"] ==0:
			SaveGame.data["player_ship"] = 1  # Change the value in-memory
			SaveGame.Write_save(SaveGame.data)  # Save to JSON file
			get_tree().reload_current_scene()	
		# Reload the JSON file to reflect real-time changes
		var updated_data = SaveGame.read_save()
		if updated_data:
			SaveGame.data = updated_data  # Update global data storage
			spcaeNumber = updated_data.get("player_ship", 0)  # Get updated value
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	player_Health()
	save_points()
	
	if Global.curr_health<=0:
		set_process(false) 
<<<<<<< HEAD
=======
=======
<<<<<<< HEAD
	player_Health()
	save_points()
=======

	
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e

>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	# Call player_spawner with the updated spcaeNumber
	player_spawner(spcaeNumber)
	deff_manager()

func  _physics_process(delta: float) -> void:
	if Global.curr_health<=0:
		if Global.count>SaveGame.data["score"]:
			SaveGame.data["score"]=(Global.count)
			SaveGame.Write_save(SaveGame.data)
<<<<<<< HEAD
			
		
		end()
=======
<<<<<<< HEAD
			
		
		end()
=======
<<<<<<< HEAD
			
=======
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
		
		get_tree().reload_current_scene()	
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
#printt(enemy_1_timer.wait_time,enemy_2_timer.wait_time,_3_rdenemy.wait_time,_3_rdenemy.time_left,enemy_4_timer.wait_time,enemy_4_timer.time_left,next_threshold)
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
	if Global.count>=70:
		
		if not spawn3_called:
			var new_enemy3 = preload("res://enemys/enemy_paths.tscn").instantiate()
			add_child(new_enemy3)
			Global.total_enemy3 += 1
			spawn3_called = true  # Mark as called to prevent immediate re-trigger
	
func spawn4()->void:
	if Global.count>=40:
		if not spawn3_called:
<<<<<<< HEAD
			warning.play("warning")
=======
<<<<<<< HEAD
			warning.play("warning")
=======
<<<<<<< HEAD
			warning.play("warning")
=======
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
			var new_enemy4=preload('res://enemys/enemy_4.tscn').instantiate()
			new_enemy4.global_position=enemy_4_marker.global_position
			add_child(new_enemy4)
			spawn4_called=true
			
	

func deff_manager() -> void:
	
	
	if Global.count >= next_threshold:
		
		enemy_1_timer.wait_time = max(enemy_1_timer.wait_time - 0.5, 1.0)
		enemy_2_timer.wait_time = max(enemy_2_timer.wait_time - 0.5, 2.0)
		_3_rdenemy.wait_time = max(_3_rdenemy.wait_time - 5, 10.0)
		enemy_4_timer.wait_time=max(enemy_4_timer.wait_time - 5,10.0)
		
		next_threshold += 50

	
func enemy1_deff():
	
	spawn()
	Global.total_enemy1+=1
	
	
func enemy2_deff():
	if Global.count>=15:
		spawn2()
		Global.total_enemy2+=1
	


func enemy3_deff():
	
		
	if Global.count >= 70  :
		spawn3() 
		Global.total_enemy3+=1 # Call spawn3 only once when conditions are met
		
func enemy4_deff():
	if Global.count>=40:
		spawn4()	
	
		
		
func _on_timer_timeout() -> void:
	enemy1_deff()
	


func _on_enemy_2_timer_timeout() -> void:
	enemy2_deff()
	
	

func _on_rdenemy_timeout() -> void:

	spawn3_called=false
	spawn3()


func _on_enemy_4_timer_timeout() -> void:
	spawn4()
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
	
func player_Health():
	Player_health.max_value=Global.max_heath
	Player_health.value=Global.curr_health
func save_points():
	if Global.curr_health<=0:
		
		SaveGame.data["Points"]+=Global.count
		SaveGame.Write_save(SaveGame.data)
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
func  end():
	if Global.curr_health<=0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		set_process(false)
<<<<<<< HEAD
		get_tree().change_scene_to_file("res://end_game.tscn")
=======
	end_game.visible=true
=======
=======
>>>>>>> 300c7676a22ee73a9530bb4d3e91b595305b503e
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
>>>>>>> 9cfaa71f1dac9b053287b9bd0ca6687662758a5e
