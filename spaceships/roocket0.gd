extends CharacterBody2D

@export var rotation_speed = 5.0
@export var dead_zone_threshold = 0  # Minimum mouse velocity length to rotate
var wall_bounce_strength = 15.0 # Read from main.gd
@onready var gun: MeshInstance2D = $gun
@export var bullet:PackedScene
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var enemy=get_tree().get_nodes_in_group("enemy1")
@onready var enemy2=get_tree().get_nodes_in_group("enemy2")
@onready var area_2d: Area2D = $'../Area2D'
@onready var area_2d_2: Area2D = $Area2D2
@export var joy:PackedScene
@export var shooting:PackedScene
@onready var rocket: CharacterBody2D = $'.'
@onready var spaceship: Node2D = $'..'


var rs_look = Vector2(0,0)
var deadzone = 0.2
var base_speed = 40000.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.curr_health=Global.max_heath
	#$AudioStreamPlayer2D.play()
	
	
func take_damage()->void:
	Global.curr_health-=2
	if Global.curr_health<=0:
		spaceship.queue_free()
func _process(delta: float) -> void:
	if Global.curr_health<=0:
		set_process(false) 	
func _physics_process(delta: float) -> void:
	# Get input direction for movement
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * base_speed * delta
	move_and_slide()
	
	# Read the bounce strength from main.gd dynamically so inspector changes take effect instantly
	var current_bounce = 50.0
	if get_parent() and "wall_bounce_strength" in get_parent():
		current_bounce = get_parent().wall_bounce_strength
		
	# Invisible boundary box: Keep the spaceship strictly inside the camera with a bounce
	if global_position.x < 45.0:
		global_position.x = 45.0 + current_bounce
	elif global_position.x > 1107.0:
		global_position.x = 1107.0 - current_bounce
		
	if global_position.y < 45.0:
		global_position.y = 45.0 + current_bounce
	elif global_position.y > 603.0:
		global_position.y = 603.0 - current_bounce
		
	# Final clamp just in case they set bounce to an insanely high number (like 5000)
	global_position.x = clamp(global_position.x, 45.0, 1107.0)
	global_position.y = clamp(global_position.y, 45.0, 603.0)
	rslook()
	# Rotate character based on mouse movement direction
	var target_angle: float = rotation  # Start with current rotation as default
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_velocity = Input.get_last_mouse_velocity()
		
		# Check if mouse movement is significant
		if mouse_velocity.length() > dead_zone_threshold:
			target_angle = mouse_velocity.angle()
	else:
		# If mouse is visible, use its global position to rotate
		pass

	# Smoothly interpolate rotation to target angle
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Toggle mouse visibility when pressing 'end'
	if Input.is_action_just_pressed("end") :
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func rslook():
	# Get joystick input for the right stick
	rs_look.y = Input.get_action_strength("rotate_down") - Input.get_action_strength("rotate_up")
	rs_look.x = Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left")

	# Check if joystick input is beyond the deadzone threshold
	if rs_look.length() > deadzone:
		var target_angle=rs_look.angle()
		# Calculate the target angle based on joystick directio
		
		
		# Smoothly interpolate rotation towards the target angle
		rotation = lerp_angle(rotation, target_angle, rotation_speed * get_physics_process_delta_time())


		
func shoot()->void:
	var new_bullet=bullet.instantiate()
	new_bullet.global_position=%shotting_point.global_position
	new_bullet.global_rotation=%shotting_point.global_rotation
	%shotting_point.add_child(new_bullet)
func _on_timer_timeout() -> void:
	if ray_cast_2d.is_colliding() :
		shoot()
	elif  ray_cast_2d_2.is_colliding() :
		shoot()
	elif  ray_cast_2d_3.is_colliding() :
		shoot()

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body  .is_in_group("enemy1"):
		body.increase_speed()
		


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body  .is_in_group("enemy2"):
		body.dec_speed()

func apply_speed_buff():
	base_speed = 60000.0
	await get_tree().create_timer(5.0).timeout
	base_speed = 40000.0

var is_rapid_fire_360 = false
func apply_rapid_fire_360():
	if is_rapid_fire_360: return
	is_rapid_fire_360 = true
	var end_time = Time.get_ticks_msec() + 2000
	while Time.get_ticks_msec() < end_time and is_inside_tree():
		var num_bullets = 16
		for i in range(num_bullets):
			var b = bullet.instantiate()
			b.global_position = global_position
			b.rotation = i * (TAU / num_bullets)
			spaceship.add_child(b) # roocket0.gd parent is spaceship
		await get_tree().create_timer(0.15).timeout
	is_rapid_fire_360 = false

func apply_shield():
	Global.is_invincible = true
	
	var shield_scene = load("res://powerups/tier_2/shield_powerup_aura.tscn")
	if shield_scene:
		var shield_aura = shield_scene.instantiate()
		add_child(shield_aura)
	
	await get_tree().create_timer(5.0).timeout
	Global.is_invincible = false

func apply_death_beam():
	var death_ray_scene = load("res://bullets/player_deathray.tscn")
	if death_ray_scene:
		var ray = death_ray_scene.instantiate()
		if has_node("%death_ray_point"):
			%death_ray_point.add_child(ray)
		else:
			add_child(ray)
			ray.position = Vector2(0, -35)
			ray.rotation = -PI / 2.0

func apply_black_hole(pos: Vector2):
	var bh_scene = load("res://powerups/tier_3/black_hole.tscn")
	if bh_scene:
		var bh = bh_scene.instantiate()
		get_tree().current_scene.add_child(bh)
		bh.global_position = get_viewport_rect().size / 2.0

func apply_chrono_shift():
	var chrono_scene = load("res://powerups/tier_3/chrono_shift_controller.tscn")
	if chrono_scene:
		var chrono = chrono_scene.instantiate()
		get_tree().current_scene.add_child(chrono)

func apply_wingmen():
	var drone_count = randi_range(2, 5)
	var drone_scene = load("res://powerups/tier_3/drone.tscn")
	if drone_scene:
		for i in range(drone_count):
			var drone = drone_scene.instantiate()
			drone.player = self
			drone.angle = (PI * 2.0 / drone_count) * i
			get_tree().current_scene.add_child(drone)

func apply_emp(pos: Vector2):
	var emp_scene = load("res://powerups/tier_3/emp_blast.tscn")
	if emp_scene:
		var emp = emp_scene.instantiate()
		get_tree().current_scene.add_child(emp)
		emp.global_position = pos

func apply_chain_lightning():
	var chain_scene = load("res://powerups/tier_3/chain_lightning.tscn")
	if chain_scene:
		var chain = chain_scene.instantiate()
		get_tree().current_scene.add_child(chain)
