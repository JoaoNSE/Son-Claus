extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var initial_pos = 200
export(int) var end_pos = 600
export(int) var speed = 10
export(int) var pontos = 1

var tempo = 0
onready var base_y = position.y

func _ready():
	$Tween.interpolate_property(self, "position:x", initial_pos, end_pos, (end_pos-initial_pos)/speed,Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()
	#$Tween3.interpolate_property(self, "position:y", base_y,16+base_y, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	#$Tween3.start()
	set_process(true)

func _process(delta):
	tempo += delta
	position.y = base_y + sin(tempo*10) * 16


func _on_Tween_tween_completed(object, key):
	$Tween2.interpolate_property(self, "position:x", initial_pos, end_pos, (end_pos-initial_pos)/speed,Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Sprite.flip_h = false
	$Tween2.start()


func _on_Tween2_tween_completed(object, key):
	$Sprite.flip_h = true
	$Tween.interpolate_property(self, "position:x", end_pos, initial_pos, (end_pos-initial_pos)/speed,Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()

func dano():
	gamestate.pontos += pontos
	queue_free()
	
func _on_Bat_body_entered(body):
	if body.is_in_group("Player"):
		var gp = global_position
		var dir = body.global_position - gp
		dir = sign(dir.x)
		if dir == 0:
			dir = 1
		body.knockBack(dir)
