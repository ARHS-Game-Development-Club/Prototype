extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var look_direction := Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(_delta: float) -> void:
	var input_vector := Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)
	if input_vector.length() > 0.0 and input_vector != look_direction:
		look_direction = input_vector
		flip_h = sign(look_direction.x) == -1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
