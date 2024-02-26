extends Area2D

var bodies_in_hitbox = []
var _i_frames_done = true
@onready var health= $"../HealthComponent"

func _on_body_entered(body):
	if bodies_in_hitbox.has(body.name) == false:
		bodies_in_hitbox.append(body.name)
		
		
func _on_body_exited(body):
	if bodies_in_hitbox.has(body.name):
		bodies_in_hitbox.erase(body.name)
		
		
func _process(delta):
	#print(bodies_in_hitbox)
	check_for_enemies(delta)
	
	
func check_for_enemies(delta):
	if _i_frames_done:
		if bodies_in_hitbox.has("jimmy"):
			var attack = Attack.new()
			attack.attack_damage = 20
			health.damage(attack)
			i_frames_on(1)
			
		elif bodies_in_hitbox.has("Zombie Husk Guy"):
			var attack = Attack.new()
			attack.attack_damage = 30
			health.damage(attack)
			i_frames_on(1)
			
			
func i_frames_on(seconds : float):
	_i_frames_done = false
	
	await get_tree().create_timer(seconds).timeout
	_i_frames_done = true
	
