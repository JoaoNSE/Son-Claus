extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 500 # pixels/sec
const ACCELERATION = 0.2

const DASH_SPD = 3000

#Jumps
const JUMP_SPEED = 650
const JUMP_FALL_MULT = 2.5
const JUMP_LOW_MULT = 2.0

const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const ATTACK_TIME_ANIM = 0.5
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.4
const KNOCKBACK_DURATION = 2

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var on_wall = false
var attack_time=99999

var dash_time = 0
var dash_cool_time = 0
var dashing = false
var can_dash = true

var can_move = true
var knockback_timer = 0

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite
onready var arma = $Arma
onready var feet1 = $Feet1
onready var feet2 = $Feet2
onready var wall1 = $Pivot/Wall1
onready var wall2 = $Pivot/Wall2

func _physics_process(delta):
	#increment counters

	dash_time += delta
	dash_cool_time += delta
	attack_time += delta
	knockback_timer += delta
	
	#detecting floor
	on_floor = feet1.is_colliding() or feet2.is_colliding()
	on_wall = wall2.is_colliding() or wall2.is_colliding()

	### MOVEMENT ###
	# Apply Atrito
	if on_floor:
		if linear_vel.x > 0:
			linear_vel.x -= 10
		if linear_vel.x < 0:
			linear_vel.x += 10

	# Apply Gravity
	if !dashing:
		if !on_floor and on_wall and linear_vel.y >= 0:
			linear_vel.y = delta * GRAVITY_VEC.y*8
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
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	# Jumping
	if can_move and Input.is_action_just_pressed("jump"):
		if on_floor:
			linear_vel.y = -JUMP_SPEED
		elif on_wall:
			linear_vel.y = -JUMP_SPEED
			linear_vel.x = sign(int(sprite.flip_h)*2 - 1) * 2 * JUMP_SPEED
		#$sound_jump.play()

	### CONTROL ###

	var target_speed = 0
	# Horizontal Movement
	if can_move:
		if Input.is_action_pressed("move_left"):
			target_speed += -1
		if Input.is_action_pressed("move_right"):
			target_speed +=  1
	
		target_speed *= WALK_SPEED
		
		linear_vel.x = lerp(linear_vel.x, target_speed, ACCELERATION)
	
	#DASH
	if Input.is_action_just_pressed("dash") and can_dash and can_move:
		linear_vel.x += DASH_SPD * sign(int(sprite.flip_h)*2 - 1)*-1
		dashing = true
		dash_time = 0
		dash_cool_time = 0
		can_dash = false
		
	if dash_time > DASH_DURATION:
		dashing = false
	
	if dash_cool_time > DASH_COOLDOWN:
		can_dash = true
		
	
	if Input.is_action_pressed("attack") and attack_time >= 0.6 and can_move:
		attack_time = 0
		
	if Input.is_action_just_pressed("ui_accept"):
		knockBack(-1)

	##ANIMTATION
	
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
			
	elif can_move:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			to_left()
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			to_right()
			
			
	if attack_time < ATTACK_TIME_ANIM:
		new_anim = "attack"
		
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
	sprite.flip_h = true
	arma.rotation = PI
	$Pivot.rotation = PI
	
func to_right():
	sprite.flip_h = false
	arma.rotation = 0
	$Pivot.rotation = 0


func _on_Arma_Area_body_entered(body):
	if body.is_in_group("Atacavel"):
		body.dano()
