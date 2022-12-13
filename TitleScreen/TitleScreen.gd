extends Control


var scene_load

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	#$"TitleScreen/Buttons/Start".grab_focus()
	#for button in $TitleScreen/Buttons.get_children():
	$Buttons/Start.connect("pressed", self, "on_button_pressed", [$Buttons/Start.scene_to_load])
	$Buttons/Quit.connect("pressed", self, "on_button_pressed", [$Buttons/Quit.scene_to_load])
	
func on_button_pressed(scene_to_load):
	scene_load = scene_to_load
	if scene_load == "ExitGame":
		get_tree().quit()
	else:
		get_tree().change_scene(scene_load)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
