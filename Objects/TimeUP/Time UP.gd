extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var c5 = Rect2(5, 4, 25, 17)
var c10 = Rect2(33, 4, 34, 15)
var c15 = Rect2(70, 4, 34, 15)

var n = 5

var tempo = 0
var base_y = 0

onready var sprite = $Sprite
var can_catch = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)
	$Timer.wait_time = $Particles2D.lifetime
	
func _process(delta):
	tempo += delta
	position.y = base_y + sin(tempo*2) * 5

func set_rect(m):
	n = m
	if n == 5:
		sprite.region_rect = c5
	if n == 10:
		sprite.region_rect = c10
		print("DEEEEZ")
	if n == 15:
		sprite.region_rect = c15
		
func set_n():
	get_tree().root.get_node("Fase").adiciona_tempo(n)
	$Sprite.queue_free()
	$Timer.start()
	$Particles2D.emitting = true
	can_catch = false
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Time_UP_body_entered(body):
	if !can_catch:
		return
	if body.is_in_group("Player"):
		set_n()


func _on_Timer_timeout():
	queue_free()
