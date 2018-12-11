extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var tempo_restante = 200

onready var timer = $Timer
onready var pontosLbl = $CanvasLayer/MarginContainer/HBoxContainer/Pontos
onready var tempoLbl = $CanvasLayer/MarginContainer/HBoxContainer/Tempo

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	timer.wait_time = tempo_restante
	timer.start()
	set_process(true)

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	tempo_restante = int(timer.time_left)
	pontosLbl.text = "Pontos: " + str(gamestate.pontos)
	tempoLbl.text = "Tempo: " + str(stepify(tempo_restante, 0))

func adiciona_tempo(n):
	tempo_restante += n
	timer.stop()
	timer.wait_time = tempo_restante
	timer.start()
	
func _on_Timer_timeout():
	get_tree().change_scene("res://Cenas/GameOver.tscn")
