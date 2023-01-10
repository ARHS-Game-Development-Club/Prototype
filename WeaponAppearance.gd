extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var look_direction := Vector2.RIGHT
var player;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent();
func _process(_delta: float) -> void:
	if (player.ded):
		return;
	var input_vector := Vector2(
		float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")),
		float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))
	)
	if input_vector.length() > 0.0 and input_vector != look_direction:
		look_direction = input_vector
		flip_h = sign(look_direction.x) == -1.0
		position = Vector2(look_direction.x*8, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
