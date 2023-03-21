extends Node2D

# cam's pivot point is the top left btw

onready var character := get_parent().get_node("Player")
onready var cam := get_parent().get_node("Camera2D")
var pos_cursor = Vector2.ZERO;
# cam's dimensions. divide by 2 2 get halfway point
export var camLength_x = 480;
export var camLength_y = 270;
# current room the player is in. start room at 0,0
export var player_currentRoom = [0, 0];
# pixel coordinates of top left corner of room (pivot point)
var room_position = Vector2(0, 0);
# the cam's intreprelolation speed
const lerp_m = 3;
# M stands for multiplier btw. parallax is when the rendering is affected sligtly by changes in the position of 
# something
# setting parallax to 1 means it moves the entire screen
const parallax_player_m = .1;
const parallax_cursor_m = .1;


# on init()
func _ready():
	pass;
# Update()
func unpause():
	# referenced in pausescreen.gd
	get_parent().get_node("PauseScreen").hide()
	get_tree().paused = false
	
func _process(_delta: float) -> void:
	# quit hotkey for exiting the window quickly (PRESS DEL)
	if (Input.is_action_just_pressed("QUIT")):
		get_tree().paused = true
		get_parent().get_node("PauseScreen").show()
	
		
	# feel free to move these 2 things to another script
	pos_cursor = get_viewport().get_mouse_position();
	# calculates player's room
	var room_x = floor(character.position.x / camLength_x);
	var room_y = floor(character.position.y / camLength_y);
	if (player_currentRoom[0] != room_x || player_currentRoom[1] != room_y):
		# player is in a different room than previous frame
		OnRoomChange(room_x, room_y);
	# lineraly intrepollolaties the cam's position to its desired position
	var parallax_player_offset = Vector2(character.position.x - cam.position.x, character.position.y - cam.position.y);
	var parallax_cursor_offset = Vector2(pos_cursor.x - (camLength_x / 2), pos_cursor.y - (camLength_y / 2));
	parallax_player_offset *= parallax_player_m;
	parallax_cursor_offset *= parallax_cursor_m;
	var pos_new = Vector2(player_currentRoom[0] * camLength_x, player_currentRoom[1] * camLength_y) + parallax_player_offset + parallax_cursor_offset;
	var pos_old = cam.position;
	var dir = (pos_new - pos_old);
	var direction_magnitude = dir.length();
	# the ternary operator makes it so that it doesn't move agonizingly slow when it only has a few pixels to go
	var step = lerp_m * _delta if (direction_magnitude > 10) else (11 - direction_magnitude) * lerp_m * _delta;
	# as you can see we are doing the linear inteporlation
	cam.position = lerp(pos_old, pos_new, step);
	
# this is called when the player's room changes
func OnRoomChange(x: int, y: int):
	player_currentRoom[0] = x;
	player_currentRoom[1] = y;
	room_position = Vector2(player_currentRoom[0] * camLength_x, player_currentRoom[1] * camLength_y);
