extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var frente = $Frente

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		frente.hide()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		frente.show()
