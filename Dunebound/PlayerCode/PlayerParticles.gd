extends Node

@onready var player = $"../Player"
@onready var particle = $"SandParticles"
var direction: int = 0

func _process(delta):
	direction = player.player_movement_direction
	if direction != 0 && player.is_on_floor():
		set_particles_on(true)
	else:
		set_particles_on(false)


func set_particles_on(isOn:bool):
	if isOn:
		particle.emitting = true
		#Y + 60 to be at player's feet
		particle.global_position.x = Global.Player.global_position.x
		particle.global_position.y = Global.Player.global_position.y + 60
		if direction == 1:
			particle.orbit_velocity_min = 0.1
			particle.orbit_velocity_max = 0.1
			
		if direction == -1:
			particle.orbit_velocity_min = -0.1
			particle.orbit_velocity_max = -0.1
	else:
		particle.emitting = false
