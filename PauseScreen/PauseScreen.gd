extends Control


var scene_load

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	$Buttons/Resume.connect("pressed", self, "on_button_pressed", [$Buttons/Resume.scene_to_load])
	$Buttons/Quit.connect("pressed", self, "on_button_pressed", [$Buttons/Quit.scene_to_load])
	get_tree().paused = true;
	
func on_button_pressed(scene_to_load):
	scene_load = scene_to_load
	if scene_load == "Unpause":
		get_parent().get_node("Camera2D").unpause()
	else:
		get_tree().change_scene(scene_load)
		
	get_tree().paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position = get_parent().get_node("Camera2D").position;
