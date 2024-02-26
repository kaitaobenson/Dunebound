extends Node

func set_particles_on(isOn:bool):
	var particle = $SandParticles
	var direction = %Player.player_direction
	
	if isOn:
		particle.emitting = true
		#Y + 60 to be at player's feet
		particle.global_position.x = Global.PlayerX
		particle.global_position.y = Global.PlayerY + 60
		if direction == 1:
			particle.orbit_velocity_min = 0.1
			particle.orbit_velocity_max = 0.1
			
		if direction == -1:
			particle.orbit_velocity_min = -0.1
			particle.orbit_velocity_max = -0.1
	else:
		particle.emitting = false
