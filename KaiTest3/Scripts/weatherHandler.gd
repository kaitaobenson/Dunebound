extends Node2D
#Daylength in Seconds

const DAY_LENGTH:float = 10
const PHASE_LENGTH:float = DAY_LENGTH / 6.0
const BEGIN_PHASE:float = 0

var elapsedTime:float = 0.0
var totalElapsedTime:float = 0.0

#Gradient for Night / Day
var gradientResource = load("res://Assets/Textures/DayNightGradient.tres")

func _ready():
	update_temperature()

func _process(delta):
	update_temperature()
	
	elapsedTime += delta
	totalElapsedTime += delta
	day_night_visuals()
	if elapsedTime >= PHASE_LENGTH:
		new_day_phase()

func new_day_phase():
	elapsedTime = 0
	if Global.TimeOfDay < 6:
		Global.TimeOfDay += 1
	else:
		Global.TimeOfDay = 1
		Global.DayCount += 1
		
func day_night_visuals():
	var colorValue:float = (sin(PI / DAY_LENGTH * (totalElapsedTime + DAY_LENGTH * BEGIN_PHASE - 0.5)) + 1) / 2
	$"../CanvasModulate".set_color(gradientResource.sample(colorValue))
	$"../Background/CanvasModulate".set_color(gradientResource.sample(colorValue))
	
func update_temperature():
	var heatValue:float = (sin(PI / DAY_LENGTH * (totalElapsedTime + DAY_LENGTH * BEGIN_PHASE - 0.5)) + 1) / 2
	Global.temperature = heatValue * 100
