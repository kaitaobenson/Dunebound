extends Area2D

#first is damage, second is if it stops for i frames
#spikes and bottom barrier don't care about i frames
const enemy_info = {
	"BottomBarrierDeath" : [100, false],
	"ScorpionTurret": [10, true],
	"BugEnemy": [20, true],
	"ZombieHusk": [0, true],
	"TurretBullet": [40, true],
	"CloseRangeExplosion": [0, true],
	"Healer" : [-100, true],
	"Checkpoint" : [0, false],
}

const i_frame_time: float = 0.5

var bodies_in_hurtbox = []
var areas_in_hurtbox = []

@onready var health_component = $"../HealthComponent"

var _i_frames_done = true
var timer : float = 0

func _process(delta):
	check_for_enemies()
	
	if Global.is_storming && !is_in_water():
		make_attack(0.1)
	
	if is_in_barrier():
		Global.camera.shake(20)
	if is_in_checkpoint():
		Global.kai_ui_container.get_node("Checkpoint").checkpoint()


func _on_body_entered(body):
	if body.has_method("get_damage_id"):
		var damage_id = body.get_damage_id()
		if !bodies_in_hurtbox.has(damage_id):
			bodies_in_hurtbox.append(damage_id)


func _on_body_exited(body):
	if body.has_method("get_damage_id"):
		var damage_id = body.get_damage_id()
		if bodies_in_hurtbox.has(damage_id):
			bodies_in_hurtbox.erase(damage_id)


func _on_area_entered(area):
	if area.has_method("get_damage_id"):
		var damage_id = area.get_damage_id()
		if !areas_in_hurtbox.has(damage_id):
			areas_in_hurtbox.append(damage_id)


func _on_area_exited(area):
	if area.has_method("get_damage_id"):
		var damage_id = area.get_damage_id()
		if areas_in_hurtbox.has(damage_id):
			areas_in_hurtbox.erase(damage_id)



func check_for_enemies():
	for i in range(bodies_in_hurtbox.size()):
		if enemy_info.has(bodies_in_hurtbox[i]):
			var current_info = enemy_info.get(bodies_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					
					i_frames_on(i_frame_time)
			if current_info[1] == false:
				make_attack(current_info[0])
				
	for i in range(areas_in_hurtbox.size()):
		if enemy_info.has(areas_in_hurtbox[i]):
			var current_info = enemy_info.get(areas_in_hurtbox[i])
			
			if current_info[1] == true:
				if _i_frames_done:
					make_attack(current_info[0])
					i_frames_on(i_frame_time)
			if current_info[1] == false:
				make_attack(current_info[0])


func i_frames_on(seconds: float):
	_i_frames_done = false
	await get_tree().create_timer(seconds).timeout
	_i_frames_done = true


func make_attack(damage: float):
	var attack = Attack.new()
	attack.attack_damage = damage
	health_component.damage(attack)


func is_in_water() -> bool:
	if areas_in_hurtbox.has("Water"):
		return true
	else:
		return false

func is_in_checkpoint() -> bool:
	if areas_in_hurtbox.has("Checkpoint"):
		return true
	else:
		return false

func is_in_barrier() -> bool:
	if areas_in_hurtbox.has("BottomBarrierDeath"):
		return true
	else:
		return false
