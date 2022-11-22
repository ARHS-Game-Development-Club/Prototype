extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed := 150
export var dashSpeed := 450

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	var move_direction = input_vector.normalized()
	
	if Input.is_action_just_pressed("dash"):
		move_and_slide(move_direction*1500)
	else:
		move_and_slide(speed*move_direction)
		
	if Input.is_action_pressed("left_click"):
		$Weapon.play("Attack")
	else:
		$Weapon.play("Idle")
		
	
