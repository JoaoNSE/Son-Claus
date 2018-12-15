extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	playing = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_AnimatedSprite_animation_finished():
	get_tree().change_scene("res://Cenas/Menu.tscn")
