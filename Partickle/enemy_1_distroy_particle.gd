extends GPUParticles2D

@onready var timeCreatrd=Time.get_ticks_msec()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

<<<<<<< HEAD
	
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec()-timeCreatrd>1000:
		queue_free()
<<<<<<< HEAD
	if Global.curr_health<=0:
		set_process(false) 
=======
>>>>>>> 8d055c48b492178c95668b86d3764df2e08ad6f9
