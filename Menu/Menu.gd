extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Container/VBoxContainer/Start.grab_focus()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Cenas/Main.tscn")
	
func _on_Exit_pressed():
	get_tree().quit()
