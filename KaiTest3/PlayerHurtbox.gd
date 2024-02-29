extends Area2D

var bodies_in_hurtbox = []
var areas_in_hurtbox = []

#first is damage, second is if it stops for i frames
#spikes and bottom barrier don't care about i frames
const enemy_info = {
	"Spikes": [100, false],
	"BottomBarrierDeath" : [100, false],
	"jimmy": [20, true],
	"Zombie Husk Guy": [0, true],
}


var _i_frames_done = true
@onready var health_component = $"../HealthComponent"

var timer : float = 0

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
	check_for_shelter()
	check_for_enemies()
	regen_health(delta)
		
func regen_health(delta):
	timer += delta
	if timer >= 1:
		timer = 0
		if (false) && (health_component.health != 100):
			make_attack(-5)
	
	
func check_for_enemies():
	for i in range(bodies_in_hurtbox.size()):
		if enemy_info.has(bodies_in_hurtbox[i]):
			var current_info = enemy_info.get(bodies_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					i_frames_on(1)
			if current_info[1] == false:
				make_attack(current_info[0])
				
	for i in range(areas_in_hurtbox.size()):
		if enemy_info.has(areas_in_hurtbox[i]):
			var current_info = enemy_info.get(areas_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					i_frames_on(1)
			if current_info[1] == false:
				make_attack(current_info[0])
				
				
func i_frames_on(seconds : float):
	_i_frames_done = false
	await get_tree().create_timer(seconds).timeout
	_i_frames_done = true
	
	
func make_attack(damage : int):
	print(damage)
	var attack = Attack.new()
	attack.attack_damage = damage
	health_component.damage(attack)
	
	
func check_for_shelter():
	if bodies_in_hurtbox.has("Shelter"):
		print("shelter")


