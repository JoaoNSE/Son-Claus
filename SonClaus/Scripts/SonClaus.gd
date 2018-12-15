extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const CAM_SWITCH_TIME = 1.0
const CAM_SMOOTH_SPEED = 10
const WALK_SPEED = 500 # pixels/sec
const ACCELERATION = 0.2

const DASH_SPD = 3000

#Jumps
const JUMP_SPEED = 650
const JUMP_FALL_MULT = 2.5
const JUMP_LOW_MULT = 2.0

const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const ATTACK_TIME_ANIM = 0.55
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.4
const KNOCKBACK_DURATION = 2

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var p_on_floor = false
var on_wall = false
var attack_time=99999

var dash_time = 0
var dash_cool_time = 0
var dashing = false
var can_dash = true

var can_move = true
var knockback_timer = 0

var gifting = false
var crounch = false

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite
onready var arma = $Arma
onready var feet1 = $Feet1
onready var feet2 = $Feet2
onready var wall1 = $Pivot/Wall1
onready var wall2 = $Pivot/Wall2
onready var camera = $CameraOffset/Camera2D
onready var cam_tween = $CameraOffset/Tween

onready var foot_p = preload("res://SonClaus/FootParticles.tscn")
onready var breath_p = preload("res://SonClaus/BreathParticles.tscn")
onready var slide_p = preload("res://SonClaus/SlideParticles.tscn")

func _physics_process(delta):
	#increment counters

	dash_time += delta
	dash_cool_time += delta
	attack_time += delta
	knockback_timer += delta
	onair_time += delta
	
	#detecting floor
	on_floor = feet1.is_colliding() or feet2.is_colliding()
	on_wall = wall1.is_colliding() or wall2.is_colliding()

	### MOVEMENT ###
	# Apply Atrito
	if on_floor:
		if linear_vel.x > 0:
			linear_vel.x -= 10
		if linear_vel.x < 0:
			linear_vel.x += 10
			
		

	# Apply Gravity
	if !dashing:
		#se tiver agarrando na parede
		if !on_floor and on_wall and linear_vel.y >= 0:
			linear_vel.y = delta * GRAVITY_VEC.y*8
			# Apply force against the wall
			if linear_vel.x == 0:
				linear_vel.x += sign(int(sprite.flip_h)*2 - 1) * 200
		else:
			linear_vel += delta * GRAVITY_VEC
		
		# Move and Slide
		#linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		
		if linear_vel.y < 0:
			linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_FALL_MULT - 1) * delta
		#elif linear_vel.y > 0 and !Input.is_action_pressed("jump"):
		#	linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_LOW_MULT - 1) * delta
	
	if dashing:
		linear_vel.y = 0
	#linear_vel += delta * GRAVITY_VEC
	var temp_l_y = linear_vel.y
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	# Jumping
	if can_move and Input.is_action_just_pressed("jump"):
		if on_floor:
			#pula pra cima
			linear_vel.y = -JUMP_SPEED
			#instancia fumacinha
			var temp_p = foot_p.instance()
			temp_p.position = Vector2(0, 32)
			temp_p.emitting = true
			add_child(temp_p)
			onair_time = 0
			crounch = false
			
		elif on_wall:
			#pula pro lado
			linear_vel.y = -JUMP_SPEED
			linear_vel.x = sign(int(sprite.flip_h)*2 - 1) * 2 * JUMP_SPEED
			crounch = false
		#$sound_jump.play()
	
	if can_move and on_floor and Input.is_action_pressed("crounch"):
		crounch = true
		linear_vel.x -= sign(int(sprite.flip_h)*2 - 1) * -1 * 10
	else:
		crounch = false

	### CONTROL ###

	var target_speed = 0
	# Horizontal Movement
	if can_move and !crounch:
		if Input.is_action_pressed("move_left"):
			target_speed += -1
		if Input.is_action_pressed("move_right"):
			target_speed +=  1
	
		target_speed *= WALK_SPEED
		
		linear_vel.x = lerp(linear_vel.x, target_speed, ACCELERATION)
		crounch = false
		
	#DASH
	if Input.is_action_just_pressed("dash") and can_dash and can_move:
		linear_vel.x += DASH_SPD * sign(int(sprite.flip_h)*2 - 1)*-1
		dashing = true
		dash_time = 0
		dash_cool_time = 0
		can_dash = false
		crounch = false
		
	if dash_time > DASH_DURATION:
		dashing = false
	
	if dash_cool_time > DASH_COOLDOWN:
		can_dash = true
		
	
	if Input.is_action_pressed("attack") and attack_time >= 0.6 and can_move:
		attack_time = 0
		crounch = false
		#cam_tween.interpolate_property($Pivot/CameraOffset, "position", position, Vector2(2000, 0), 10, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#cam_tween.start() 

	##ANIMTATION
	#fumacinha quando cai
	if on_floor and !p_on_floor and temp_l_y > 10:
		#instancia fumacinha
		var temp_p = foot_p.instance()
		temp_p.position = Vector2(0, 32)
		temp_p.emitting = true
		add_child(temp_p)
	p_on_floor = on_floor
	
	var new_anim = "idle"
	
	if knockback_timer <= KNOCKBACK_DURATION:
		pass
	else:
		can_move = true

	if on_floor and can_move:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			to_left()
			
		if linear_vel.x > SIDING_CHANGE_SPEED:
			to_right()
			
		if abs(linear_vel.x) > 100:
			new_anim = "running"
			
	elif can_move and on_wall:
		new_anim = "slide"
	
	elif can_move:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			to_left()
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			to_right()
			
		if onair_time <= 0.1:
			new_anim = "jump_start"
		elif linear_vel.y < 0:
			new_anim = "jumping"
		if linear_vel.y > 0:
			new_anim = "falling"
	elif !gifting:
		new_anim = "knockback_air"
		if on_floor:
			new_anim = "knockback_ground"
		
			
	if attack_time < ATTACK_TIME_ANIM and !on_wall:
		new_anim = "attack"
	
	if crounch:
		new_anim = "crounch"
	
	if dashing:
		new_anim = "dash"
		
	if gifting:
		new_anim = "gifts"
	
		
	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)
		
	

#knocback recebe direção (-1, 1)
func knockBack(dir):
	if !can_move:
		return
	var vec = Vector2(.4, -.6)
	vec.x *= dir
	linear_vel.x = 0
	linear_vel += vec * 800
	can_move = false
	dashing = false
	dash_time = 0
	dash_cool_time = DASH_COOLDOWN
	knockback_timer = 0

func to_left():
	#mudar a camera
	if !sprite.flip_h:
		#$Pivot/CameraOffset.position = Vector2(0, 0)
		cam_tween.interpolate_property($CameraOffset, "position:x", $CameraOffset.position.x, -208, CAM_SWITCH_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		cam_tween.start()                                                        
	sprite.flip_h = true
	arma.rotation = PI
	$Pivot.scale.x = -1
	if sign($Breath.position.x) >=0: 
		$Breath.position.x *= -1
	
	
	
func to_right():
	#mudar a camera
	if sprite.flip_h:
		#$Pivot/CameraOffset.position = Vector2(0, 0)
		cam_tween.interpolate_property($CameraOffset, "position:x", $CameraOffset.position.x, 208, CAM_SWITCH_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		cam_tween.start()
		  
		#cam_switching_time = 0
	sprite.flip_h = false
	arma.rotation = 0
	$Pivot.scale.x = 1
	if sign($Breath.position.x) < 0: 
		$Breath.position.x *= -1
	

func _on_Arma_Area_body_entered(body):
	if body.is_in_group("Atacavel"):
		body.dano()

func _on_Arma_Area_area_entered(area):
	if area.is_in_group("Atacavel"):
		area.dano()
		
func _emit_breath():
	var temp_p = breath_p.instance()
	temp_p.position = $Breath.position
	if sign(temp_p.position.x) >= 0:
		temp_p.rotation = 0
	else:
		temp_p.rotation = PI
	temp_p.emitting = true
	$Breath.add_child(temp_p)
	
func _emit_slide_p():
	var temp_p = slide_p.instance()
	if !sprite.flip_h:
		temp_p.position = Vector2(8, -22)
		temp_p.rotation = 0
	else:
		temp_p.position = Vector2(-8, -22)
		temp_p.rotation = PI
	temp_p.emitting = true
	$Breath.add_child(temp_p)
