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
export var speed_max = 40;
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
# can be both
var attacks_available = [true, false]
# 0: normal attacking 1: ranged attacking 2: returning to startPos
var move_action = 0;
var pos_start;
# change in the inspector, this is the hp that the enemy has
export var hpMax = 100;
export var base_damage = 10;
var damage_timer = 0;
var hp;
var ded = false;
var dash_timer = 0;
var dir_dash = Vector2.ZERO;
# chance for entity to dash at player
var dash_chance = .0;
# change to true in the inspector if you want the enemy to move in tiles
export var doesEntityMoveInTiles = true;
# 9 x 9
var tileWidth = 9;
var pos_target_sub = Vector2.ZERO;
var tileMovement_timer = 0;

# period of invicibility after entity gets hit
const invincibility_timer = .5;

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
	hp = hpMax;
	get_node("Area").connect("body_entered", self, "OnBodyEnter")

 # update
func _process(delta: float):
	if (ded):
		return;
	damage_timer = max(0, damage_timer - delta);
	sprite.modulate = lerp(sprite.modulate, player.color_normal, delta * 3);
	
func OnBodyEnter(body: Node):
	print("hello")
	if (body == player):
		# collided with the player
		body.Damage(base_damage, self);

# physics update
func _physics_process(delta: float):
	if (ded):
		return;
	# not dead :
	Move(delta);
	if (dash_timer > 0 && aggroed):
		dash_timer = max(dash_timer - delta, 0);
		move_and_slide(dir_dash * speed_max * 2);
	
# Determine movement
func Move(delta: float):
	if (pos_target == Vector2(0, 0)):
		return;
	velocity += (pos_target - position).normalized() * acceleration;
	# will revert the velocity to the maximum speed in magnitude it can go
	velocity = min(speed_max, velocity.length()) * velocity.normalized();
	
	if (doesEntityMoveInTiles):
		# lotsa stuff here. what this does is i. move player to center of tile or ii. move player to adjacent tile
		tileMovement_timer += delta;
		if ((pos_target_sub - position).length() < 1 || tileMovement_timer > 1):
			pos_target_sub = Vector2(position.x - (int(position.x) % tileWidth), position.y - (int(position.y) % tileWidth));
			pos_target_sub += Vector2(tileWidth / 2, tileWidth / 2);
			var delta_x = pos_target.x - position.x;
			var delta_y = pos_target.y - position.y;
			tileMovement_timer = 0;
			if (rand_range(0, 2) < abs(delta_x / delta_y)):
				# randomly goes to the tile to the right or left
				pos_target_sub += Vector2(delta_x, 0).normalized() * tileWidth;
			else:
				# randomly goes to the tile to the up or down
				pos_target_sub += Vector2(0, delta_y).normalized() * tileWidth;
		velocity = speed_max * (pos_target_sub - position).normalized();
		
	
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
			
		if (doesEntityMoveInTiles):
			# locks on to top left of tile
			pos_target = Vector2(pos_target.x - (int(pos_target.x) % tileWidth), pos_target.y - (int(pos_target.y) % tileWidth))
			# goes to middle of tile
			pos_target += Vector2(tileWidth / 2, tileWidth / 2);
		
		if (rand_range(0, 1) < dash_chance):
			Dash(1, player.get_position());
		
		var lookDirection = Vector2(1, 1);
		var dir = (pos_target - position).normalized();
		if (dir.x < 0):
			lookDirection = Vector2(-1, 1);
		sprite.scale = lookDirection;
		weapon.scale = lookDirection;
		weapon.position = Vector2(lookDirection.x * 3, 4)
		
# dashing towards its target position
func Dash(time: float, pos_target: Vector2):
	dash_timer = time;
	dir_dash = (pos_target - position).normalized();
		
# Used when the coroutine has been previously disabled and needs to be re-enabled
func SetCoroutines(activeState: bool):
	coroutines_running = activeState;
	if (coroutines_running):
		call("Move_Target");
		
# sender is of type Node, can be Player node. invinciility happens after entity gets attacked, can be overriden
func Damage(dmg: float, sender = null, overrideInvincibility = false):
	if (damage_timer > 0 && !overrideInvincibility):
		return;
	var damage = dmg;
	hp = max(0, hp - damage)
	if (hp == 0):
		Die();
	# is called when the player hits this entity
	if (sender == player):
		pass;
	damage_timer += invincibility_timer;
	sprite.modulate = player.color_red;

func Die():
	ded = true;
	sprite.modulate = player.color_red;
	SetCoroutines(false);
