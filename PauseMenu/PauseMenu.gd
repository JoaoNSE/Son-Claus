extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	hide()
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause()

func pause():
	get_tree().paused = true
	show()
	$CenterContainer/VBoxContainer/Resume.grab_focus()
	
func unpause():
	get_tree().paused = false
	hide()

func _on_Resume_pressed():
	unpause()

func _on_Exit_pressed():
	unpause()
	get_tree().change_scene("res://Cenas/Menu.tscn")
