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

var player = null

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
			if player != null:
				player.can_move = false
				player.gifting = true
			FBtn.hide()
			if timer.is_stopped():
				timer.start()
				progress.show()
		else:
			if player != null:
				player.can_move = true
				player.gifting = false
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
		player = body

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player_on = false
		player = null


func _on_Timer_timeout():
	able = false
	player.can_move = true
	player.gifting = false
	timer.stop()
	startUi()
	FBtn.hide()
	gamestate.pontos += 1
