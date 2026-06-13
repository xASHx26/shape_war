extends Node
@export var count: int = 100
@export var total_enemy3:int=1
@export var total_enemy1:int=1
@export var total_enemy2:int=1
@export var max_heath:int=10000  # TODO: revert to 10 after testing
var is_invincible: bool = false
var shield_health: int = 0
var max_shield: int = 15
var is_time_frozen: bool = false

var curr_health:int:
	set(health_in):
		if is_invincible and health_in < curr_health:
			return # Ignore damage while invincible
		if health_in < curr_health:
			var damage = curr_health - health_in
			if shield_health > 0:
				if shield_health >= damage:
					shield_health -= damage
					return # Damage completely absorbed by shield
				else:
					damage -= shield_health
					shield_health = 0
					curr_health -= damage # Apply remaining damage to health
					return
		curr_health=health_in
		print("[HP] Health changed to: ", curr_health, " / ", max_heath)

var active =SaveGame.data.get(["player_ship"])
