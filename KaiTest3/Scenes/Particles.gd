extends Node2D

var particleIsOn = false

	
func off1():
	particleIsOn = false
	
func _process(delta):
	particles()

func particles():
	var particle = $SandParticles
	var direction = %Player.direction
	
	particle.visible = true
	particle.emitting = false
	
	while particleIsOn:
		particle.emitting = true
#		Y + 60 to be at player's feet
		particle.global_position.x = Global.PlayerX
		particle.global_position.y = Global.PlayerY + 60
		
		if direction == 1:
			particle.orbit_velocity_min = 0.1
			particle.orbit_velocity_max = 0.1
	
		if direction == -1:
			particle.orbit_velocity_min = -0.1
			particle.orbit_velocity_max = -0.1


func particles_on():
	particleIsOn = true
