extends Node2D

#Daylength in Seconds
const Daylength:float = 10

const DaySection:float = Daylength / 6
var elapsedTime = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	elapsedTime += delta
	time_of_day_cycle()
	print(Global.TimeOfDay)

	if elapsedTime >= Daylength:
		new_day()

func new_day():
	elapsedTime = 0

func time_of_day_cycle():
	var i = 0
	while i < 6:
		if (elapsedTime >= DaySection * i) && (elapsedTime < DaySection * (i + 1)):
			Global.TimeOfDay = i + 1
		i += 1
	
	"""
	# DayBegin
	if (elapsedTime >= DaySection * 0) && (elapsedTime < DaySection * 1):
		Global.TimeOfDay = 1
	# DayMid
	if (elapsedTime >= DaySection * 1) && (elapsedTime < DaySection * 2):
		Global.TimeOfDay = 2
	# DayEnd
	if (elapsedTime >= DaySection * 2) && (elapsedTime < DaySection * 3):
		Global.TimeOfDay = 3
	# NightBegin
	if (elapsedTime >= DaySection * 3) && (elapsedTime < DaySection * 4):
		Global.TimeOfDay = 4
	# NightMid
	if (elapsedTime >= DaySection * 4) && (elapsedTime < DaySection * 5):
		Global.TimeOfDay = 5
	# NightEnd
	if (elapsedTime >= DaySection * 5) && (elapsedTime < DaySection * 6):
		Global.TimeOfDay = 6
	"""
