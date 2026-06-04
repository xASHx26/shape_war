extends CharacterBody2D

# Adjustable rotation speed for smooth turning
@export var rotation_speed = 5.0
@export var dead_zone_threshold = 0  # Minimum mouse velocity length to rotate
@onready var gun: MeshInstance2D = $gun
@export var bullet:PackedScene
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var enemy=get_tree().get_nodes_in_group("enemy1")
@onready var enemy2=get_tree().get_nodes_in_group("enemy2")
@onready var area_2d: Area2D = $'../Area2D'
@onready var area_2d_2: Area2D = $Area2D2

		
var rs_look = Vector2(0,0)
var deadzone = 0.2
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.curr_health=Global.max_heath
	
	
func take_damage()->void:
	Global.curr_health-=2
	if Global.curr_health<=0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	# Get input direction for movement
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * 40000 * delta
	move_and_slide()
	rslook()
	# Rotate character based on mouse movement direction
	var target_angle: float = rotation  # Start with current rotation as default
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_velocity = Input.get_last_mouse_velocity()
		
		# Check if mouse movement is significant
		if mouse_velocity.length() > dead_zone_threshold:
			target_angle = (mouse_velocity - global_position).angle()
	else:
		# If mouse is visible, use its global position to rotate
		pass

	# Smoothly interpolate rotation to target angle
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Toggle mouse visibility when pressing 'end'
	if Input.is_action_just_pressed("end"):
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
