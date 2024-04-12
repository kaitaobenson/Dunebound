extends Node
#Daylength in Seconds

const NUMBER_OF_PHASES : float = 6.0
const DAY_LENGTH:float = 10
const PHASE_LENGTH:float = DAY_LENGTH / NUMBER_OF_PHASES
const BEGIN_PHASE:float = 1


var elapsedTime:float = 0.0
var totalElapsedTime:float = 0.0

@export var sandstorm_is_on: bool = false

@onready var _particles = $"CanvasLayer/CPUParticles2D"
@onready var _storm_overlay  = $"CanvasLayer/StormOverlay"

#Gradient for Night / Day
var gradientResource = load("res://Assets/Textures/DayNightGradient.tres")

func _ready():
	update_temperature()

func _process(delta):
	sandstorm()
	update_temperature()
	
	elapsedTime += delta
	totalElapsedTime += delta
	day_night_visuals()
	if elapsedTime >= PHASE_LENGTH:
		new_day_phase()

func new_day_phase():
	elapsedTime = 0
	if Global.TimeOfDay < NUMBER_OF_PHASES:
		Global.TimeOfDay += 1
	else:
		Global.TimeOfDay = 1
		Global.DayCount += 1
		
func day_night_visuals():
	var colorValue:float = (sin(2 * PI / DAY_LENGTH * (totalElapsedTime - DAY_LENGTH * (0.25 + BEGIN_PHASE / NUMBER_OF_PHASES) - 1)) + 1) / 2
	$"../CanvasModulate".set_color(gradientResource.sample(colorValue))
	$"../BackgroundContainer/ParallaxBackground/CanvasModulate".set_color(gradientResource.sample(colorValue))
	
func update_temperature():
	var heatValue:float = (sin(2 * PI / DAY_LENGTH * (totalElapsedTime - DAY_LENGTH * (0.25 + BEGIN_PHASE / NUMBER_OF_PHASES) - 1)) + 1) / 2
	Global.temperature = heatValue * 100

func sandstorm():
	if sandstorm_is_on:
		_particles.set_emitting(true)
		_storm_overlay.set_visible(true)
	else:
		_particles.set_emitting(false)
		_storm_overlay.set_visible(false)
