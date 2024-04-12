extends Node

@export var wind_frequency: float = 5
@export var wind_randomness: float = 3

@onready var wind1 = preload("res://Scenes/Wind/Wind1.tscn")
@onready var wind2 = preload("res://Scenes/Wind/Wind2.tscn")
@onready var wind3 = preload("res://Scenes/Wind/Wind3.tscn")
@onready var wind4 = preload("res://Scenes/Wind/Wind4.tscn")
var total_different_winds = 4

var wind_time: float
var previous_wind_done: bool = true
var not_generated_wind_yet: bool = true

var timer: float = 0

func _ready():
	pass

func _process(delta):
	await get_tree().create_timer(6).timeout
	
	if previous_wind_done && not_generated_wind_yet:
		not_generated_wind_yet = false
		wind_time = wind_frequency + randf_range(-wind_randomness, wind_randomness)
	
	timer += delta
	
	if timer >= wind_time:
		timer = 0
		var wind_type = randi_range(1, total_different_winds)
		if wind_type == 1:
			add_child(wind1.instantiate())
		elif wind_type == 2:
			add_child(wind2.instantiate())
		elif wind_type == 3:
			add_child(wind3.instantiate())
		elif wind_type == 4:
			add_child(wind4.instantiate())
		
		previous_wind_done = true
		not_generated_wind_yet = true
