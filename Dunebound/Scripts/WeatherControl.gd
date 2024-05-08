extends Node

@export var current_phase: float = 1.0
@export var enabled: bool = true
@export var sandstorm_is_on: bool = false

@onready var sandstorm_bar = $"../KaiUI/Sandstorm"
@onready var _particles = $"CanvasLayer/CPUParticles2D"
@onready var _storm_overlay  = $"CanvasLayer/StormOverlay"
@onready var canvas_modulate1 = $"../CanvasModulate"
@onready var canvas_modulate2 = $"../../BackgroundContainer/ParallaxBackground/CanvasModulate"

#Daylength in Seconds
const DAY_LENGTH: float = 100
const PHASE_LENGTH: float = DAY_LENGTH / 6.0
const DAYS_UNTIL_SANDSTORM: int = 1
const SANDSTORM_TIME: float = 10

#Elapsed time this new day phase
@onready var today_elapsed_time:float = 0

#Total elapsed time while playing game
@onready var total_elapsed_time:float = (current_phase - 1) * PHASE_LENGTH + 0.01

#Phase shizz
var can_change_phase: bool = true

#Gradient for Night / Day
var gradientResource: Gradient = load("res://Assets/Textures/DayNightGradient.tres")
var day_night_color_value: float = 0.0


var one = true
var two = true
var three = true
var four = true
var five = true
var six = true


func _ready():
	Global.DAY_LENGTH = DAY_LENGTH
	Global.phase_length = PHASE_LENGTH
	Global.begin_phase = current_phase
	
	update_temperature()
	if enabled:
		pass
		
	else:
		Global.temperature = 50
		await get_tree().process_frame
		await get_tree().process_frame
		set_process(false)
		Global.temperature = 50


func _process(delta):
	if !sandstorm_is_on:
		day_night_visuals()
		update_temperature()
	update_color()
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
		if current_phase == 1 && one:
			one = false
			can_change_phase = false
			
			day_night_color_value = 0.5
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0, PHASE_LENGTH - 0.1).set_trans(Tween.TRANS_LINEAR).finished
			
			two = true
			can_change_phase = true
		
		
		#Stay at 0
		if current_phase == 2 && two:
			two = false
			can_change_phase = false
			
			day_night_color_value = 0
			await get_tree().create_timer(PHASE_LENGTH - 0.1).timeout
			
			three = true
			can_change_phase = true
		
		
		#Go to 0.5
		if current_phase == 3 && three:
			three = false
			can_change_phase = false
			
			day_night_color_value = 0
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0.5, PHASE_LENGTH - 0.1).set_trans(Tween.TRANS_LINEAR).finished
			
			four = true
			can_change_phase = true
		
		
		#Go to 1
		if current_phase == 4 && four:
			four = false
			can_change_phase = false
			
			day_night_color_value = 0.5
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 1, PHASE_LENGTH - 0.1).set_trans(Tween.TRANS_LINEAR).finished
			
			five = true
			can_change_phase = true
		
		
		#Stay at 1
		if current_phase == 5 && five:
			five = false
			can_change_phase = false
			
			day_night_color_value = 1
			await get_tree().create_timer(PHASE_LENGTH - 0.1).timeout
			
			six = true
			can_change_phase = true
		
		
		#Go to 0.5
		if current_phase == 6 && six:
			six = false
			can_change_phase = false
			
			day_night_color_value = 1
			await get_tree().create_tween().tween_property(self, "day_night_color_value", 0.5, PHASE_LENGTH - 0.1).set_trans(Tween.TRANS_LINEAR).finished
			
			one = true
			can_change_phase = true


func update_color():
	#Set canvas modulate color from gradient
	canvas_modulate1.color = gradientResource.sample(day_night_color_value)
	canvas_modulate2.color = gradientResource.sample(day_night_color_value)


func update_temperature():
	Global.temperature = day_night_color_value * 100


func sandstorm():
	sandstorm_visuals()
	var bar_level = fmod((total_elapsed_time / DAY_LENGTH), DAYS_UNTIL_SANDSTORM) / DAYS_UNTIL_SANDSTORM * 100
	sandstorm_bar.set_bar(bar_level)
	
	if round(bar_level) == 99:
		sandstorm_is_on = true
		await get_tree().create_timer(SANDSTORM_TIME).timeout
		sandstorm_is_on = false


func sandstorm_visuals():
	if sandstorm_is_on:
		Global.is_storming = true
		_storm_overlay.visible = true
		_particles.set_emitting(true)
	else:
		Global.is_storming = false
		_particles.set_emitting(false)
		_storm_overlay.visible = false
