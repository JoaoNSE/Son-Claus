extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Start.grab_focus()
	#pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Cenas/Cutscene1.tscn")
	
func _on_Exit_pressed():
	get_tree().quit()
