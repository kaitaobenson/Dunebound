extends Node2D

@onready var area = $"Area2D"
@onready var anim = $"AnimatedSprite2D"
@onready var begin_smoke = $"Smoke"
@onready var fire1 = $"Fire1"
@onready var fire2 = $"Fire2"

var begin_position: Vector2
var rocket_finished: bool = false

var machine_parts_returned: int = 0

func _init():
	Global.rocket = self


func _ready():
	begin_position = position
	
	fire1.emitting = false
	fire2.emitting = false
	begin_smoke.emitting = true
	visuals()

func _process(delta):
	if area.get_overlapping_bodies().has(Global.Player):
		if Global.collected_machine_parts > machine_parts_returned:
			machine_parts_returned = Global.collected_machine_parts
			visuals()
		
		if (machine_parts_returned == Global.total_machine_parts):
			if !rocket_finished:
				rocket_finished = true
				takeoff()


func visuals():
	var shakey: int = 10
	for i in 10:
		var x_offset = randi_range(-shakey, shakey)
		var y_offset = randi_range(-shakey, shakey)
		
		position = Vector2(begin_position.x + x_offset, begin_position.y + y_offset)
		await get_tree().create_timer(0.02).timeout
	
	position = begin_position
	
	anim.frame = machine_parts_returned
	
	if machine_parts_returned > 0:
		begin_smoke.emitting = false


func takeoff():
	await get_tree().create_timer(1).timeout
	Global.camera.is_in_rocket_mode = true
	
	get_tree().create_tween().tween_property(Global.Player, "modulate:a", 0, 2)
	
	await get_tree().create_timer(1).timeout
	
	for i in 30:
		#Global.camera.shake(20)
		await get_tree().create_timer(0.02).timeout
	
	fire1.emitting = true
	fire2.emitting = true
	
	var speed = 3
	while position.y > -3000:
		#Global.camera.shake(20)
		position.y -= speed
		speed += 0.1
		await get_tree().create_timer(0.02).timeout
	
	await Global.fader.fade_in()
	Global.root_node.change_level_to_scene("res://Scenes/Levels/WinScreen.tscn")
	
	
