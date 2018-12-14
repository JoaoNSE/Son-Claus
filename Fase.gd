extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var tempo_limite = 200
var tempo_restante

onready var timer = $Timer
onready var pontosLbl = $CanvasLayer/MarginContainer/HBoxContainer/Pontos
onready var tempoLbl = $CanvasLayer/MarginContainer/HBoxContainer/Tempo

onready var barril = preload("res://Objects/Barril.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	tempo_restante = tempo_limite
	timer.wait_time = tempo_restante
	timer.start()
	set_process(true)

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	tempo_restante = int(timer.time_left)
	pontosLbl.text = "Pontos: " + str(gamestate.pontos)
	tempoLbl.text = "Tempo: " + str(stepify(tempo_restante, 0))
	if Input.is_action_just_pressed("presente"):
		var coin = barril.instance()
		coin.position = Vector2(134, 448)
		$Mapa1.add_child(coin)

func adiciona_tempo(n):
	tempo_restante += n
	timer.stop()
	timer.wait_time = tempo_restante
	timer.start()
	
func _on_Timer_timeout():
	get_tree().change_scene("res://Cenas/GameOver.tscn")
