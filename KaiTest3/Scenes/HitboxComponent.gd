extends Area2D

var bodies_in_hurtbox = []
var areas_in_hurtbox = []

var timer_is_done = true

const enemy_info = {
	"AttackHitbox" : 50
}

@export var health_component : HealthComponent

func _on_body_entered(body):
	if bodies_in_hurtbox.has(body.name) == false:
		bodies_in_hurtbox.append(body.name)
		
		
func _on_body_exited(body):
	if bodies_in_hurtbox.has(body.name):
		bodies_in_hurtbox.erase(body.name)
		
		
func _on_area_entered(area):
	if areas_in_hurtbox.has(area.name) == false:
		areas_in_hurtbox.append(area.name)
		
		
func _on_area_exited(area):
	if areas_in_hurtbox.has(area.name):
		areas_in_hurtbox.erase(area.name)
		
		
func _process(delta):
	check_for_enemies()
	
	
func check_for_enemies():
	for i in range(bodies_in_hurtbox.size()):
		if enemy_info.has(bodies_in_hurtbox[i]):
			var current_info = enemy_info.get(bodies_in_hurtbox[i])
			make_attack(current_info)
			
	for i in range(areas_in_hurtbox.size()):
		if enemy_info.has(areas_in_hurtbox[i]):
			var current_info = enemy_info.get(areas_in_hurtbox[i])
			make_attack(current_info)
				
				
func make_attack(damage : int):
	if timer_is_done:
		timer_is_done = false
		
		var attack = Attack.new()
		attack.attack_damage = damage
		health_component.damage(attack)
		
		await get_tree().create_timer(0.11).timeout
		timer_is_done = true
