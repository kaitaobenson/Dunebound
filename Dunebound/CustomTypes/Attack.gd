extends Node

class_name Attack

enum ATTACKS{
	SHORT_KNIFE,
	LONG_SPEAR,
	
}

var attack_type: ATTACKS
var attack_damage: float
var knockback_force: float
var stun_time: float

