extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player = get_parent().get_node("SonClaus")
onready var init = $Init
onready var end = $End
onready var vis = $Visibility

var oMap

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for i in get_tree().get_nodes_in_group("Mapa"):
		if i != self:
			oMap = i
	set_process(true)

func _process(delta):
	if player.global_position.x > init.global_position.x and player.global_position.x < end.global_position.x:
		var posLocal = global_position.x - init.global_position.x
		var posOutro = oMap.global_position.x - oMap.get_node("Init").global_position.x
		var tamLocal = abs(end.position.x - init.position.x)
		var tamOutro = oMap.get_node("Init").global_position.x - oMap.get_node("End").global_position.x
		if player.global_position.x <= init.global_position.x + tamLocal/2:
			#player.get_node("Sprite").modulate = Color(0, 0, 0)
			oMap.position = Vector2(global_position.x + tamOutro, oMap.global_position.y)
			#oMap.position = Vector2(global_position.x + tamOutro, oMap.global_position.y)
		if player.global_position.x > init.global_position.x + tamLocal/2:
			#player.get_node("Sprite").modulate = Color(1, 1, 1)
			oMap.position = Vector2(global_position.x + tamLocal, oMap.global_position.y)
	
	
	
	