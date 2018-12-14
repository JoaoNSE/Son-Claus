extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var timeUP = preload("res://Objects/TimeUP/Time UP.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func dano():
	var n = rand_range(0, 1)
	var chance = get_chance()
	print("Número: " + str(n))
	print("Chance: " + str(chance))
	if n <= chance:
		var tm_chance = n*10/chance*10
		var timeup = timeUP.instance()
		timeup.position = Vector2(position.x, position.y)
		timeup.base_y = position.y
		get_parent().add_child(timeup)
		var m = 5
		if tm_chance <= 50:
			m = 5
		elif tm_chance > 50 and tm_chance <= 90:
			m = 10
		elif tm_chance > 90:
			m = 15
		timeup.set_rect(m)
		queue_free()
	

func get_chance():
	
	var TL = get_tree().root.get_node("Fase").tempo_limite
	var TA = get_tree().root.get_node("Fase").tempo_restante
	
	var chance = ((float(TL-TA))/float(TL))+0.2
	if chance > 1.0:
		chance = 1.0
	return chance