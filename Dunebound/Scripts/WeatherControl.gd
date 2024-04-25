extends Node

@export var current_phase: float = 1
@export var enabled: bool = true
@export var sandstorm_is_on: bool = false

@onready var _particles = $"CanvasLayer/CPUParticles2D"
@onready var _storm_overlay  = $"CanvasLayer/StormOverlay"
@onready var canvas_modulate1 = $"../CanvasModulate"
@onready var canvas_modulate2 = $"../../BackgroundContainer/ParallaxBackground/CanvasModulate"

#Daylength in Seconds
const DAY_LENGTH: float = 100
const PHASE_LENGTH: float = DAY_LENGTH / 6.0
const DAYS_UNTIL_SANDSTORM: int = 10

#Elapsed time this new day phase
var today_elapsed_time:float = 0.0

#Total elapsed time while playing game
var total_elapsed_time:float = 0.0

#Phase shizz
var can_change_phase: bool = true

#Gradient for Night / Day
var gradientResource: Gradient = load("res://Assets/Textures/DayNightGradient.tres")
var day_night_color_value: float = 0.0


func _ready():
	Global.DAY_LENGTH = DAY_LENGTH
	
	if enabled:
		update_temperature()
		set_process(true)
	else:
		Global.temperature = 50
		await get_tree().process_frame
		await get_tree().process_frame
		set_process(false)
		Global.temperature = 50
	
	day_night_visuals()


func _process(delta):
	day_night_visuals()
	update_color()
	update_temperature()
	sandstorm()
	
	today_elapsed_time += delta
	total_elapsed_time += delta
	
	if today_elapsed_time > DAY_LENGTH:
		today_elapsed_time = 0.1
		Global.day_count += 1
	
	# / 6 round up to get current phase number
	current_phase = ceil(today_elapsed_time / PHASE_LENGTH)


func day_night_visuals():
	if can_change_phase:
		#Go to 0
		if current_phase == 1:
			can_change_phase = false
			day_night_color_value = 0.5
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0, PHASE_LENGTH).set_trans(Tween.TRANS_LINEAR).finished
			can_change_phase = true
		#Stay at 0
		if current_phase == 2:
			can_change_phase = false
			day_night_color_value = 0
			await get_tree().create_timer(PHASE_LENGTH).timeout 
		#Go to 0.5
		if current_phase == 3:
			can_change_phase = false
			day_night_color_value = 0
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0.5, PHASE_LENGTH).set_trans(Tween.TRANS_LINEAR).finished
			can_change_phase = true
		#Go to 1
		if current_phase == 4:
			can_change_phase = false
			day_night_color_value = 0.5
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 1, PHASE_LENGTH).set_trans(Tween.TRANS_LINEAR).finished
			can_change_phase = true
		#Stay at 1
		if current_phase == 5:
			can_change_phase = false
			day_night_color_value = 1
			await get_tree().create_timer(PHASE_LENGTH).timeout
			can_change_phase = true
		#Go to 0.5
		if current_phase == 6:
			can_change_phase = false
			day_night_color_value = 1
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0.5, PHASE_LENGTH).set_trans(Tween.TRANS_LINEAR).finished
			can_change_phase = true


func update_color():
	#Set canvas modulate color from gradient
	canvas_modulate1.color = gradientResource.sample(day_night_color_value)
	canvas_modulate2.color = gradientResource.sample(day_night_color_value)


func update_temperature():
	Global.temperature = day_night_color_value * 100


func sandstorm():
	sandstorm_visuals()
	if Global.day_count % DAYS_UNTIL_SANDSTORM == 0:
		sandstorm_is_on = true


func sandstorm_visuals():
	if sandstorm_is_on:
		_particles.set_emitting(true)
		_storm_overlay.set_visible(true)
	else:
		_particles.set_emitting(false)
		_storm_overlay.set_visible(false)
