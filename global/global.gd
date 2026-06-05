extends Node
@export var count: int = 100
@export var total_enemy3:int=1
@export var total_enemy1:int=1
@export var total_enemy2:int=1
@export var max_heath:int=100000000
var is_invincible: bool = false
var curr_health:int:
	set(health_in):
		if is_invincible and health_in < curr_health:
			return # Ignore damage while invincible
		curr_health=health_in
var active =SaveGame.data.get(["player_ship"])
