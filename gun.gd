extends Area2D
func _physics_process(delta: float) -> void:
	var range_enemy=get_overlapping_bodies()
	if range_enemy.size()>0:
		var target_enemy=range_enemy.front()
		look_at(target_enemy.global_position)
