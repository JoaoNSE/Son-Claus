extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		start_game()

func start_game():
	get_tree().change_scene("res://Cenas/Main.tscn")
