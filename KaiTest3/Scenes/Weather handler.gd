extends Node2D
var cyclelength = 10
var elapsedtime = 0
func _ready():
	pass # Replace with function body.

func new_cycle():
	elapsedtime = 0
	#Whatever you want to do with new parts of days, we can make this more complicated later

func _process(delta):
		elapsedtime = elapsedtime + delta
		print(elapsedtime)
		if elapsedtime >= cyclelength:
			new_cycle()

