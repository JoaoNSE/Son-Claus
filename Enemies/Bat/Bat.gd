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
onready var death_p = preload("res://Enemies/DeathParticles.tscn")

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
	$Sprite.flip_h = true
	$Tween2.start()


func _on_Tween2_tween_completed(object, key):
	$Sprite.flip_h = false
	$Tween.interpolate_property(self, "position:x", end_pos, initial_pos, (end_pos-initial_pos)/speed,Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()

func dano():
	gamestate.pontos += pontos
	$Sprite.queue_free()
	monitoring = false
	$Tween.stop(self)
	$Tween2.stop(self)
	$Tween3.stop(self)
	_emit_death_p()
	
func _on_Bat_body_entered(body):
	if body.is_in_group("Player"):
		var gp = global_position
		var dir = body.global_position - gp
		dir = sign(dir.x)
		if dir == 0:
			dir = 1
		body.knockBack(dir)
		
func _emit_death_p():
	var temp_p = death_p.instance()
	temp_p.position = Vector2(0, 0)
	temp_p.emitting = true
	temp_p.get_node("FootParticlesTimer").connect("timeout", self, "queue_free")                                                
	add_child(temp_p)
