extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera_moving := false
onready var character := get_node("KinematicBody2D")
onready var camera := get_node("Camera2D")
var cameraXOffset := 240
var cameraYOffset := 135

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(_delta: float) -> void:
	if !camera_moving && character:
		var charPosX = character.position.x
		var charPosY = character.position.y
		var camPosX = camera.position.x
		var camPosY = camera.position.y
		if (charPosX > camPosX + cameraXOffset): # The main reason for the camera moving variable is that there will be smooth transitions eventually
			camera_moving = true
			camera.position = Vector2(camPosX + 2 * cameraXOffset, camPosY)
			camera_moving = false
		elif (charPosX < camPosX - cameraXOffset):
			camera_moving = true
			camera.position = Vector2(camPosX - 2 * cameraXOffset, camPosY)
			camera_moving = false
		if (charPosY > camPosY + cameraYOffset):
			camera_moving = true
			camera.position = Vector2(camPosX, camPosY + 2 * cameraYOffset)
			camera_moving = false
		elif (charPosY < camPosY - cameraYOffset):
			camera_moving = true
			camera.position = Vector2(camPosX, camPosY - 2 * cameraYOffset)
			camera_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
