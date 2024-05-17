extends Node

@export var sandstorm_is_on: bool = false

@onready var sandstorm_bar = $"../KaiUI/Sandstorm"
@onready var _particles = $"CanvasLayer/CPUParticles2D"
@onready var _storm_overlay  = $"CanvasLayer/StormOverlay"
@onready var canvas_modulate1 = $"../CanvasModulate"
@onready var canvas_modulate2 = $"../../BackgroundContainer/ParallaxBackground/CanvasModulate"
var gradientResource: Gradient = load("res://Assets/Textures/DayNightGradient.tres")

const DAY_LENGTH: int = 100
const SANDSTORM_TIME: int = 10
const DAYS_UNTIL_SANDSTORM: int = 3

var day_count: int = 0

var total_elapsed_time: float = 0.0
var color_value: float = 0.0


func _ready():
	_storm_overlay.visible = false
	if Global.saver_loader.find_saved_value("TotalElapsedTime") != null:
		total_elapsed_time = Global.saver_loader.find_saved_value("TotalElapsedTime")


func _process(delta):
	total_elapsed_time += delta
	day_count = floor(total_elapsed_time / DAY_LENGTH / 2)
	
	sandstorm()
	update_temperature()
	
	color_value = (sin(PI / DAY_LENGTH * (total_elapsed_time - DAY_LENGTH)) + 1) / 2
	canvas_modulate1.color = gradientResource.sample(color_value)
	canvas_modulate2.color = gradientResource.sample(color_value)
	
	Global.saver_loader.var_update(total_elapsed_time, "TotalElapsedTime")


func sandstorm():
	sandstorm_visuals()
	var bar_level = fmod((total_elapsed_time / DAY_LENGTH), DAYS_UNTIL_SANDSTORM) / DAYS_UNTIL_SANDSTORM * 100
	sandstorm_bar.set_bar(bar_level)
	
	if round(bar_level) == 99:
		sandstorm_is_on = true
		await get_tree().create_timer(SANDSTORM_TIME).timeout
		sandstorm_is_on = false

func update_temperature():
	Global.temperature = color_value * 100

func sandstorm_visuals():
	if sandstorm_is_on:
		Global.is_storming = true
		_storm_overlay.visible = true
		_particles.set_emitting(true)
	else:
		Global.is_storming = false
		_particles.set_emitting(false)
		_storm_overlay.visible = false
