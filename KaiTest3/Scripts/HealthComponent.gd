extends Node2D

class_name HealthComponent

@export var max_health : int = 100
@export_multiline var health_bar : String
var health : int

func _ready():
	get_node("/root/Node2D/SavingThingy").loader()
	if get_node("/root/Node2D/SavingThingy").find_saved_value("Health") <= 0:
		health = max_health
	else:
		health = get_node("/root/Node2D/SavingThingy").find_saved_value("Health")
	update_health_bar()

func damage(attack:Attack):
	health -= attack.attack_damage
	update_health_bar()
	$"../../../SavingThingy".var_update(health, "Health")
	#stop hurtbox before we die so this thing doesnt error out
	get_parent().get_node("HurtboxComponent").set_process(false)
	get_parent().get_node("HurtboxComponent").runningTheDamnCode = true
	if health <= 0:
		$"../".die()
	get_parent().get_node("HurtboxComponent").set_process(true)
	get_parent().get_node("HurtboxComponent").runningTheDamnCode = false
func update_health_bar():
	if get_node(health_bar) != null:
		get_node(health_bar).set_health(health)
