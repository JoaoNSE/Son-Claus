extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$MarginContainer/TextureRect/VBoxContainer/Pontos.text = str(gamestate.pontos)
	$MarginContainer/TextureRect/VBoxContainer/CenterContainer/Restart.grab_focus()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Restart_pressed():
	gamestate.init()
	get_tree().change_scene("res://Cenas/Menu.tscn")
