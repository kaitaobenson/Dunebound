extends Node

enum ALL_SOUNDS {
	FOOTSTEPS,
	JUMP,
	SHORT_ATTACK,
	ATTACK_CHARGED,
	SLIDE,
	
}

@onready var footsteps = $"Footsteps"
@onready var jump = $"Jump"
@onready var attack_1 = $"Attack1"
@onready var attack_2 = $"Attack2"
@onready var attack_charge = $"AttackCharge"
@onready var player = $"../"

var _footsteps_playing: bool = false
var _slide_playing: bool = false

func _process(delta):
	if _footsteps_playing:
		if !footsteps.playing:
			footsteps.play(0)
	else:
		if footsteps.playing:
			footsteps.stop()
	
	#if 


func play(sound: ALL_SOUNDS):
	if sound == ALL_SOUNDS.FOOTSTEPS:
		if player.is_on_floor_custom():
			_footsteps_playing = true
		else:
			_footsteps_playing = false
			
	if sound == ALL_SOUNDS.JUMP:
		jump.play()
	
	if sound == ALL_SOUNDS.SHORT_ATTACK:
		var random = randi_range(1, 2)
		if random == 1:
			attack_1.play()
		else:
			attack_2.play()
	
	if sound == ALL_SOUNDS.ATTACK_CHARGED:
		attack_charge.play()
	
	if sound == ALL_SOUNDS.SLIDE:
		_slide_playing = true


func stop(sound: ALL_SOUNDS):
	if sound == ALL_SOUNDS.FOOTSTEPS:
		_footsteps_playing = false
	
	if sound == ALL_SOUNDS.SLIDE:
		_slide_playing = false
