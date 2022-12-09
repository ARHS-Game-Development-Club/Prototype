extends KinematicBody2D


var sprite: Sprite;
export var speed := 150
var maxHp = 100;
var hp;
var ded = false;
var damage_timer = 0;

# period of invicibility after entity gets hit
const invincibility_timer = .5;
const color_red = Color(1, 0, 0);
const color_normal = Color(1, 1, 1, 1);

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHp;
	sprite = get_node("Sprite");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ded):
		return;
	damage_timer = max(0, damage_timer - delta);
	sprite.modulate = lerp(sprite.modulate, color_normal, delta * 3);
	
func _physics_process(delta: float) -> void:
	if (ded):
		return;
	# not dead
	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	var move_direction = input_vector.normalized()
	move_and_slide(speed*move_direction)

# sender is of type Node, can be Player node. invinciility happens after entity gets attacked, can be overriden
func Damage(dmg: float, sender = null, overrideInvincibility = false):
	if (damage_timer > 0 && !overrideInvincibility):
		return;
	var damage = dmg;
	hp = max(0, hp - damage)
	if (hp == 0):
		Die();
	damage_timer += invincibility_timer;
	sprite.modulate = color_red;

func Die():
	ded = true;
	sprite.modulate = color_red;
	# TODO: respawn stuff here
	print("PLAYER DIED");
