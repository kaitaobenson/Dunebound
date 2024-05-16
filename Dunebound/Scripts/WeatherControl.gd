extends Node

@onready var sandstorm_bar = $"../KaiUI/Sandstorm"
@onready var _particles = $"CanvasLayer/CPUParticles2D"
@onready var _storm_overlay  = $"CanvasLayer/StormOverlay"
@onready var canvas_modulate1 = $"../CanvasModulate"
@onready var canvas_modulate2 = $"../../BackgroundContainer/ParallaxBackground/CanvasModulate"
var gradientResource: Gradient = load("res://Assets/Textures/DayNightGradient.tres")

const DAY_LENGTH: int = 100

var day_count: int = 0

var total_elapsed_time: float = 0.0
var color_value: float = 0.0

func _ready():
	_storm_overlay.visible = false


func _process(delta):
	total_elapsed_time += delta
	day_count = floor(total_elapsed_time / DAY_LENGTH)
	
	color_value = (sin(PI / DAY_LENGTH * (total_elapsed_time - DAY_LENGTH)) + 1) / 2
	canvas_modulate1.color = gradientResource.sample(color_value)
	canvas_modulate2.color = gradientResource.sample(color_value)
	print(color_value)
