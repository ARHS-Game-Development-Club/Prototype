extends Node2D

# cam's pivot point is the top left btw

onready var character := get_node("KinematicBody2D")
onready var cam := get_node("Camera2D")
var pos_cursor = Vector2.ZERO;
# cam's dimensions. divide by 2 2 get halfway point
var camLength_x = 480;
var camLength_y = 270;
# current room the player is in. start room at 0,0
var player_currentRoom = [0, 0];
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
func _process(_delta: float) -> void:
	# quit hotkey for exiting the window quickly (PRESS DEL)
	if (Input.is_action_just_pressed("QUIT")):
		get_tree().quit();
	# feel free to move these 2 things to another script
	pos_cursor = get_viewport().get_mouse_position();
	# calculates player's room
	player_currentRoom[0] = floor(character.position.x / camLength_x);
	player_currentRoom[1] = floor(character.position.y / camLength_y);
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
	

# previously: (ctrl + k to undo comments) (I had to delete and redo this because man that's hard to read)
#if !camera_moving && character:
#		var charPosX = character.position.x
#		var charPosY = character.position.y
#		var camPosX = camera.position.x
#		var camPosY = camera.position.y
#		if (charPosX > camPosX + cameraXOffset): # player moves to right room
#			camera_moving = true
#			camera.position = Vector2(camPosX + 2 * cameraXOffset, camPosY)
#			camera_moving = false
#		elif (charPosX < camPosX - cameraXOffset): # player moves to left room
#			camera_moving = true
#			camera.position = Vector2(camPosX - 2 * cameraXOffset, camPosY)
#			camera_moving = false
#		if (charPosY > camPosY + cameraYOffset): # player moves to down room
#			camera_moving = true
#			camera.position = Vector2(camPosX, camPosY + 2 * cameraYOffset)
#			camera_moving = false
#		elif (charPosY < camPosY - cameraYOffset): # player moves to up room
#			camera_moving = true
#			camera.position = Vector2(camPosX, camPosY - 2 * cameraYOffset)
#			camera_moving = false
