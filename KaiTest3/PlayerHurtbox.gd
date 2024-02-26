extends Area2D

var bodies_in_hitbox = []
var countdownOver = true

func _on_body_entered(body):
	if bodies_in_hitbox.has(body.name) == false:
		bodies_in_hitbox.append(body.name)
		
		
func _on_body_exited(body):
	if bodies_in_hitbox.has(body.name):
		bodies_in_hitbox.erase(body.name)
		
		
func _process(delta):
	check_for_enemies(delta)
	
	
func check_for_enemies(delta):
	if countdownOver == true:
		if bodies_in_hitbox.has("jimmy"):
			countdownOver = false
			var attack = Attack.new()
			attack.attack_damage = 20
			$"../HealthComponent".damage(attack)
			await get_tree().create_timer(1.0).timeout
			countdownOver = true
		
