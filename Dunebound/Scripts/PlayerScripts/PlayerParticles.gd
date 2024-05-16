extends Node

@onready var player = $"../Player"
@onready var particle = $"SandParticles"
@onready var slide = $"../Player/Slide"
var direction: int = 0
var can_leave_jump_dust: bool

func _process(delta):
	direction = player.player_movement_direction
	if !player.is_on_floor_custom():
		can_leave_jump_dust = true
	
	if (direction != 0 || slide.is_sliding()) && player.is_on_floor():
		set_particles_on(true)
		
	elif !player.jumping && can_leave_jump_dust:
		set_particles_on(true)
		await get_tree().create_timer(0.2).timeout
		can_leave_jump_dust = false
		
	else:
		set_particles_on(false)


func set_particles_on(isOn:bool):
	if isOn:
		particle.emitting = true
		#Y + 60 to be at player's feet
		particle.global_position.x = Global.Player.global_position.x
		particle.global_position.y = Global.Player.global_position.y + 50
	else:
		particle.emitting = false
