extends Node2D

func _ready() -> void:
	var max_lifetime = 0.0
	
	for child in get_children():
		if child.has_method("restart"):
			child.call("restart")
			var l = float(child.get("lifetime"))
			if l > max_lifetime:
				max_lifetime = l
				
	if self.has_method("restart"):
		self.call("restart")
		var l = float(self.get("lifetime"))
		if l > max_lifetime:
			max_lifetime = l
			
	if max_lifetime > 0.0:
		await get_tree().create_timer(max_lifetime + 0.1).timeout
		queue_free()
	else:
		await get_tree().create_timer(1.0).timeout
		queue_free()
