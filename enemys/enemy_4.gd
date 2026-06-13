extends Area2D

@onready var first: Sprite2D = $first
@onready var first_c: CollisionShape2D = $first_C
@onready var _2_nd: Sprite2D = $'2nd'
@onready var _2_nd_c: CollisionShape2D = $'2nd_C'
@onready var _3_rd: Sprite2D = $'3rd'
@onready var _3_rd_c: CollisionShape2D = $'3rd_c'
@onready var _4_th: Sprite2D = $'4th'
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

func _ready():
	if body_entered.is_connected(_on_body_entered):
		body_entered.disconnect(_on_body_entered)
	body_shape_entered.connect(_on_body_shape_entered)
	
	create_aura(first)
	create_aura(_2_nd)
	create_aura(_3_rd)
	create_aura(_4_th)

func create_aura(parent_sprite: Sprite2D):
	if not is_instance_valid(parent_sprite): return
	var aura = CPUParticles2D.new()
	aura.texture = preload("res://SPRITE/PLAYER/glow.png")
	aura.amount = 20
	aura.lifetime = 1.5
	aura.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	aura.emission_sphere_radius = 800.0
	aura.gravity = Vector2.ZERO
	aura.radial_accel_min = -600.0
	aura.radial_accel_max = -400.0
	aura.scale_amount_min = 0.5
	aura.scale_amount_max = 1.5
	aura.color = Color(0.5, 0.0, 1.0, 0.4)
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	aura.material = mat
	aura.show_behind_parent = true
	parent_sprite.add_child(aura)

func _process(delta: float) -> void:
	if Global.curr_health<=0:
		set_process(false) 
	
	if is_instance_valid(first): first.rotation += delta * 3.0
	if is_instance_valid(_2_nd): _2_nd.rotation += delta * 3.0
	if is_instance_valid(_3_rd): _3_rd.rotation += delta * 3.0
	if is_instance_valid(_4_th): _4_th.rotation += delta * 3.0
func _physics_process(delta: float) -> void:
	move_objects(delta)
	
func move_objects(delta: float) -> void:
	var current_speed = speed
	if Global.is_time_frozen:
		current_speed = 0.0
	# Create a temporary list to store objects that should be removed
	var objects_to_remove = []
	for obj in active_objects:
		match obj:
			"first":
				# Check if the object still exists
				if is_instance_valid(first) and is_instance_valid(first_c):
					first.position.x -= current_speed * delta
					first_c.position.x -= current_speed * delta
					traveled_distances["first"] += current_speed * delta
					if traveled_distances["first"] > distance_limit:
						first.queue_free()
						first_c.queue_free()
						objects_to_remove.append("first")
			"second":
				if is_instance_valid(_2_nd) and is_instance_valid(_2_nd_c):
					_2_nd.position.x -= current_speed * delta
					_2_nd_c.position.x -= current_speed * delta
					traveled_distances["second"] += current_speed * delta
					if traveled_distances["second"] > distance_limit:
						_2_nd.queue_free()
						_2_nd_c.queue_free()
						objects_to_remove.append("second")
			"third":
				if is_instance_valid(_3_rd) and is_instance_valid(_3_rd_c):
					_3_rd.position.x -= current_speed * delta
					_3_rd_c.position.x -= current_speed * delta
					traveled_distances["third"] += current_speed * delta
					if traveled_distances["third"] > distance_limit:
						_3_rd.queue_free()
						_3_rd_c.queue_free()
						objects_to_remove.append("third")
			"fourth":
				if is_instance_valid(_4_th) and is_instance_valid(_4_th_c):
					_4_th.position.x -= current_speed * delta
					_4_th_c.position.x -= current_speed * delta
					traveled_distances["fourth"] += current_speed * delta
					if traveled_distances["fourth"] > distance_limit:
						_4_th.queue_free()
						_4_th_c.queue_free()
						objects_to_remove.append("fourth")

	# Remove objects from active_objects after looping
	for obj in objects_to_remove:
		active_objects.erase(obj)
		
	# If everything is completely dead, destroy the spawner
	if not is_instance_valid(first) and not is_instance_valid(_2_nd) and not is_instance_valid(_3_rd) and not is_instance_valid(_4_th):
		queue_free()

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

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not body: return
	if body.is_in_group("spaceship"):
		Global.curr_health -= 5
	elif body.is_in_group("enemy1") or body.is_in_group("enemy2") or body.is_in_group("enemy3"):
		# Determine which black hole it touched
		var target_pos = global_position
		if local_shape_index == 0 and is_instance_valid(first): target_pos = first.global_position
		elif local_shape_index == 1 and is_instance_valid(_2_nd): target_pos = _2_nd.global_position
		elif local_shape_index == 2 and is_instance_valid(_3_rd): target_pos = _3_rd.global_position
		elif local_shape_index == 3 and is_instance_valid(_4_th): target_pos = _4_th.global_position
		
		absorb_enemy(body, target_pos)

func absorb_enemy(body: Node2D, target_pos: Vector2):
	# Stop enemy logic
	body.set_physics_process(false)
	body.set_process(false)
	body.remove_from_group("enemy1")
	body.remove_from_group("enemy2")
	body.remove_from_group("enemy3")
	
	# Disable collisions safely
	for child in body.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
			
	# Find the sprite
	var sprite = null
	for child in body.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			sprite = child
			break
			
	if sprite:
		# Apply shader dynamically
		var mat = ShaderMaterial.new()
		mat.shader = preload("res://absorb.gdshader")
		sprite.material = mat
		
		# Animate the spaghettification
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(body, "global_position", target_pos, 0.8).set_trans(Tween.TRANS_SINE)
		tween.tween_property(body, "scale", Vector2(0.05, 0.05), 0.8)
		tween.tween_property(sprite.material, "shader_parameter/absorb_progress", 1.0, 0.8)
		
		tween.set_parallel(false)
		tween.tween_callback(body.queue_free)
	else:
		body.queue_free()

func _on_body_entered(body: Node2D) -> void:
	pass
