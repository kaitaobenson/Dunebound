extends ProgressBar
@onready var Health:float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	set_value_no_signal(Health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Health <= 0:
		$"../../PlayerContainer/Player".die()

func health_changed(Amount):
	Health += Amount
	set_value_no_signal(Health)
