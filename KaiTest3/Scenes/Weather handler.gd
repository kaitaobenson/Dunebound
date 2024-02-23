extends Node2D
#Daylength in Seconds

const DAY_LENGTH:float = 10
const PHASE_LENGTH:float = DAY_LENGTH / 6.0

var BEGIN_PHASE:float
var elapsedTime:float = 0.0
var totalElapsedTime:float = 0.0

#Gradient for Night / Day
var gradientResource = load("res://Assets/Textures/DayNightGradient.tres")

func _ready():
	BEGIN_PHASE = (Global.TimeOfDay / 6.0) - 0.5

func _process(delta):
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
	var colorValue:float = (cos(PI / (0.5 * DAY_LENGTH) * (totalElapsedTime + DAY_LENGTH * BEGIN_PHASE )) + 1)/ 2
	#print(str(Global.TimeOfDay) + "Value:  " + str(colorValue))
	$"../CanvasModulate".set_color(gradientResource.sample(colorValue))
	$"../Background/CanvasModulate".set_color(gradientResource.sample(colorValue))
