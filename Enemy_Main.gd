extends KinematicBody2D

# if you want to change the variables based on what instance you put the script on, then
# add 'export' before the 'var' and then change the value in the inspector

# Enemy's image
var sprite;
# Enemy's weapon
var weapon;
var cam;
var acceleration = 3;
var velocity = Vector2(0, 0);
var speed_max = 40;
# Target position
var pos_target = Vector2(0, 0);
var player;
var coroutines_running = true;
# sight distance is 1 room
var aggroed = false;
var startRoom = [0, 0];
var sightDistance = 1000;
var rangedDistance = 100;
# 0: melee, 1: ranged
var attacks_available = [true, false]
# 0: normal attacking 1: ranged attacking 2: returning to startPos
var move_action = 0;
var pos_start;

# Start()
func _ready():
	sprite = get_node("Sprite");
	# reference to the player node in the sceneview
	player = get_parent().get_node("Player");
	# Start the coroutine
	call("Move_Target");
	weapon = get_node("Weapon");
	cam = get_parent().get_node("Camera2D");
	startRoom[0] = floor(position.x / cam.camLength_x);
	startRoom[1] = floor(position.y / cam.camLength_y);
	pos_start = position;

# Update()
func _process(delta: float):
	Move(delta);
	
# Determine movement
func Move(delta: float):
	if (pos_target == Vector2(0, 0)):
		return;
	velocity += (pos_target - position).normalized() * acceleration;
	# will revert the velocity to the maximum speed in magnitude it can go
	velocity = min(speed_max, velocity.length()) * velocity.normalized();
	move_and_slide(velocity);

# Determine target
func Move_Target():
	while coroutines_running:
		# yield returns 1 second
		yield(get_tree().create_timer(1), "timeout");
		# The player is within range of the enemy
		if (startRoom == cam.get("player_currentRoom") && (player.position - position).length() < sightDistance):
			aggroed = true;
		else:
			aggroed = false;
		if (!aggroed):
			pos_target = Vector2(0, 0);
			continue;
		# only called when the enemy is aggro'd (aggravated)
		
		# determine what do
		if (startRoom != [floor(position.x / cam.camLength_x), floor(position.y / cam.camLength_y)]):
			move_action = 2;
		elif (attacks_available[1] && (player.get_position() - position).length() > rangedDistance || !attacks_available[0]):
			move_action = 1;
		else:
			move_action = 0;
		# find the target position
		if (move_action == 2):
			pos_target = pos_start;
		elif (move_action == 1 && rand_range(0, 4) < 1):
			pos_target = position + Vector2(rand_range(-50, 50), rand_range(-50, 50)); 
		elif (move_action == 0):
			pos_target = player.get_position();
		
		var lookDirection = Vector2(1, 1);
		var dir = (pos_target - position).normalized();
		if (dir.x < 0):
			lookDirection = Vector2(-1, 1);
		sprite.scale = lookDirection;
		weapon.scale = lookDirection;
		weapon.position = Vector2(lookDirection.x * 3, 4)
		
# Used when the coroutine has been previously disabled and needs to be re-enabled
func SetCoroutines(activeState: bool):
	coroutines_running = activeState;
	if (coroutines_running):
		call("Move_Target");
