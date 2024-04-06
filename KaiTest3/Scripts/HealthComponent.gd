extends Node2D

class_name HealthComponent

@export var max_health: int = 100
@export var animation_sprite: AnimatedSprite2D
@export_multiline var health_bar: String

var health : int

func _ready():
	health = max_health
	update_health_bar()


func _process(delta):
	pass


func damage(attack:Attack):
	if attack.attack_damage != 0:
		health -= attack.attack_damage
		damaged_visuals(attack.attack_damage)
		update_health_bar()
	if health <= 0:
		await get_tree().create_timer(0.2).timeout
		$"../".die()


func damaged_visuals(attack_damage: float):
	display_damage_value(attack_damage)
	flash_white(attack_damage)


func display_damage_value(attack_damage):
	if (animation_sprite != null) && (attack_damage > 0):
		var _text_label = RichTextLabel.new()
		_text_label.position = Vector2(-10,0)
		_text_label.modulate.a = 0
		_text_label.text = str(attack_damage)
		_text_label.set_size(Vector2(1000,1000))
		_text_label.scroll_active = false
		
		add_child(_text_label)
		
		var _text_label_node: RichTextLabel = get_node(str(_text_label.name))
		
		get_tree().create_tween().tween_property(_text_label_node, "modulate:a", 1, 1)
		get_tree().create_tween().tween_property(_text_label_node, "position:y", _text_label_node.position.y - 100, 1)
		
		await get_tree().create_timer(1).timeout
		_text_label_node.queue_free()


func flash_white(attack_damage):
	if (animation_sprite != null) && (attack_damage > 0):
		animation_sprite.modulate = Color(255, 255, 255)
		await get_tree().create_timer(0.2).timeout
		animation_sprite.modulate = Color(1, 1, 1, 1)


func update_health_bar():
	if get_node(health_bar) != null:
		get_node(health_bar).set_health(health)
