extends Node2D
#Daylength in Seconds
const Daylength = 60
const Phaselength = Daylength/6
var elapsedTime = 0

func _process(delta):
	elapsedTime += delta
	if elapsedTime >= Phaselength:
		new_day_phase()
		print(Global.TimeOfDay)

func new_day_phase():
	elapsedTime = 0
	Global.TimeOfDay += 1
	if Global.TimeOfDay >= 7:
		Global.TimeOfDay = 1
