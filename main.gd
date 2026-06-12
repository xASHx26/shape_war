extends Node2D

@onready var enemy_1_timer: Timer = $enemy1_timer
@onready var enemy_2_timer: Timer = $enemy2_timer
@onready var spaceship_spwaner: Marker2D = $spaceship_spwaner
@export var player:Array[PackedScene]
@export var wall_bounce_strength = 50.0
@export var starting_number: int = 0
@onready var timer: Timer = $Timer
@onready var _3_rdenemy: Timer = $'3rdenemy'
@onready var enemy_4_timer: Timer = $enemy4_timer
@onready var enemy_4_marker: Marker2D = $enemy4_marker
@onready var warning: AnimationPlayer = $AnimationPlayer
@onready var end_game: CanvasLayer = $End_game





var range_score=randi_range(10,15)
var enemy1_def:int=range_score
var enemy2_def:int
var enemy3_def:int
var next_threshold = 50  
var player_spawned = false
var player2_spawn :=false
var player1_spawn :=false

var spawn3_called = false 
var next_blackhole_score = 40 
var spcaeNumber = 0  # Default value, will be replaced after loading
var enemy5_timer_counter = 0.0

var vignette_mat: ShaderMaterial
var last_health: int = 10

func _ready() -> void:
	print(OS.get_data_dir())
	Global.count = starting_number
	Global.curr_health=10
	last_health = 10
	setup_vignette()
	print(SaveGame.data["Points"])
	var save_data = SaveGame.read_save()  # Read save data from JSON
	if save_data:
		SaveGame.data = save_data  # Store the data globally
		spcaeNumber = SaveGame.data.get("player_ship", 1)  # Get saved value
	
	
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
	player_Health()
	save_points()
	
	if Global.curr_health < last_health:
		flash_player()
	last_health = Global.curr_health
	
	if Global.curr_health<=0:
		set_process(false) 
	# Call player_spawner with the updated spcaeNumber
	player_spawner(spcaeNumber)
	deff_manager()
	spawn4()
	
	if Global.count >= 50:
		enemy5_timer_counter += delta
		if enemy5_timer_counter >= 10.0:
			enemy5_timer_counter = 0.0
			spawn5()

func  _physics_process(delta: float) -> void:
	if Global.curr_health<=0:
		if Global.count>SaveGame.data["score"]:
			SaveGame.data["score"]=(Global.count)
			SaveGame.Write_save(SaveGame.data)
			
		
		end()
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
	if Global.count >= next_blackhole_score:
		warning.play("warning")
		var new_enemy4=preload('res://enemys/enemy_4.tscn').instantiate()
		new_enemy4.global_position=enemy_4_marker.global_position
		add_child(new_enemy4)
		next_blackhole_score = Global.count + randi_range(20, 30)

func spawn5()->void:
	warning.play("warning")
	var new_enemy5 = preload('res://enemys/enemy_5.tscn').instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy5.global_position = %PathFollow2D.global_position
	add_child(new_enemy5)

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
	spawn3()


func _on_enemy_4_timer_timeout() -> void:
	pass
	
func player_Health():
	if vignette_mat:
		var health_ratio = float(Global.curr_health) / float(Global.max_heath)
		var intensity = clamp(1.0 - health_ratio, 0.0, 1.0)
		# Start showing blood when health is under 70%
		if health_ratio < 0.7:
			vignette_mat.set_shader_parameter("intensity", intensity * 1.2)
		else:
			vignette_mat.set_shader_parameter("intensity", 0.0)

func setup_vignette():
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	
	var rect = ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var shader = load("res://vignette.gdshader")
	vignette_mat = ShaderMaterial.new()
	vignette_mat.shader = shader
	rect.material = vignette_mat
	
	canvas.add_child(rect)

func flash_player():
	var player_node = get_tree().get_first_node_in_group("spaceship")
	if is_instance_valid(player_node):
		var tween = get_tree().create_tween()
		if player_node is CharacterBody2D:
			player_node.modulate = Color(1, 0, 0) # Red
			tween.tween_property(player_node, "modulate", Color(1, 1, 1), 0.3)
		elif player_node.get_parent() is CharacterBody2D:
			player_node.get_parent().modulate = Color(1, 0, 0)
			tween.tween_property(player_node.get_parent(), "modulate", Color(1, 1, 1), 0.3)
func save_points():
	if Global.curr_health<=0:
		
		SaveGame.data["Points"]+=Global.count
		SaveGame.Write_save(SaveGame.data)
var is_game_over = false

func end():
	if Global.curr_health <= 0 and not is_game_over:
		is_game_over = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		set_process(false)
		
		# 1. Slow down time
		Engine.time_scale = 0.2
		
		# 2. Disable touch controls & hide HUD
		var touch_control = get_node_or_null("CanvasLayer/Control/touchcontrol")
		if touch_control:
			touch_control.process_mode = Node.PROCESS_MODE_DISABLED
			touch_control.hide()
			
		var hud_layer = get_node_or_null("CanvasLayer")
		if hud_layer:
			hud_layer.hide()
			
		if vignette_mat:
			vignette_mat.set_shader_parameter("intensity", 0.0)
			
		# 3. Apply Pixel Fire Explosion to Player
		var player_node = get_tree().get_first_node_in_group("spaceship")
		if is_instance_valid(player_node):
			var sprite = null
			for child in player_node.get_children():
				if child is Sprite2D or child is AnimatedSprite2D:
					sprite = child
				elif child is ColorRect or child is CPUParticles2D or child is GPUParticles2D:
					# Hide/destroy the engine thruster flames which look like rockets
					child.hide()
					child.queue_free()
					
			if sprite:
				var fire_shader = load("res://shaders/pixel_fire_explosion.gdshader")
				var mat = ShaderMaterial.new()
				mat.shader = fire_shader
				sprite.material = mat
				
				# Create a tween to animate the explosion
				var tween = get_tree().create_tween()
				tween.tween_method(func(val): mat.set_shader_parameter("explosion_progress", val), 0.0, 1.0, 0.4) # 0.4 scaled seconds = 2.0 real seconds

		# 4. Explode all enemies (skip enemy 4 as requested)
		var enemies_to_explode = []
		enemies_to_explode.append_array(get_tree().get_nodes_in_group("enemy1"))
		enemies_to_explode.append_array(get_tree().get_nodes_in_group("enemy2"))
		enemies_to_explode.append_array(get_tree().get_nodes_in_group("enemy3"))
		enemies_to_explode.append_array(get_tree().get_nodes_in_group("enemy5"))
		
		for enemy in enemies_to_explode:
			if is_instance_valid(enemy):
				if enemy.has_method("explo"):
					enemy.explo()
				enemy.queue_free()

		# Shrink Enemy 4 (Black Holes) faster and perfectly clean all bullets
		_cleanup_screen(get_tree().root)

		# 5. Wait for explosion to finish before showing Game Over
		await get_tree().create_timer(2.0, false, false, true).timeout
		
		# Clean up one more time just in case the player kept shooting during the 2-second death cinematic
		_cleanup_screen(get_tree().root)
		
		# 6. Show Game Over
		get_tree().paused = true
		Engine.time_scale = 1.0
		
		var end_screen = load("res://end_game.tscn").instantiate()
		end_screen.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(end_screen)

func _cleanup_screen(node: Node) -> void:
	if not is_instance_valid(node): return
	
	if node is Area2D:
		if node.has_method("create_aura"):
			node.set_process(false)
			node.set_physics_process(false)
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			var found_sprites = false
			for c in node.get_children():
				if c is Sprite2D:
					found_sprites = true
					var mat = ShaderMaterial.new()
					mat.shader = preload("res://absorb.gdshader")
					c.material = mat
					tween.tween_property(c, "scale", Vector2(0.05, 0.05), 0.3)
					tween.tween_property(mat, "shader_parameter/absorb_progress", 1.0, 0.3)
			tween.set_parallel(false)
			if found_sprites:
				tween.tween_callback(node.queue_free)
			else:
				node.queue_free()
			return
			
		var is_projectile = false
		var n_name = node.name.to_lower()
		if "bullet" in n_name or "dagger" in n_name or "ray" in n_name or "laser" in n_name or "rocket" in n_name:
			is_projectile = true
		elif node.get_script() != null:
			var s_path = node.get_script().resource_path.to_lower()
			if "bullet" in s_path or "dagger" in s_path or "ray" in s_path or "laser" in s_path or "rocket" in s_path:
				is_projectile = true
				
		if is_projectile:
			node.queue_free()
			return
			
	for child in node.get_children():
		_cleanup_screen(child)
