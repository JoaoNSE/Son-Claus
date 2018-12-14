extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player_on = false
var time = 5
var able = true

onready var FBtn = $UI/FBtn
onready var progress = $UI/Progress
onready var label = $UI/Progress/Label
onready var timer = $Timer

func _ready():
	startUi()
	timer.wait_time = time
	set_process(true)

func _process(delta):
	if !able:
		set_process(false)
	
	if able:
		FBtn.visible = player_on
		
		if player_on and Input.is_action_pressed("presente"):
			FBtn.hide()
			if timer.is_stopped():
				timer.start()
				progress.show()
		else:
			progress.hide()
			timer.stop()
			timer.wait_time = time
			startUi()
		
	attUi()


func attUi():
	progress.value = timer.time_left
	label.text = str(stepify(timer.time_left, 0.1)) + 's'
	
func startUi():
	progress.hide()
	progress.max_value = time
	progress.value = time
	label.text = str(time)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player_on = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player_on = false


func _on_Timer_timeout():
	able = false
	timer.stop()
	startUi()
	FBtn.hide()
	gamestate.pontos += 1
