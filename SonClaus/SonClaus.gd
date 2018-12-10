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

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var attack_time=99999

var dash_time = 0
var dash_cool_time = 0
var dashing = false
var can_dash = true

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite
onready var arma = $Arma

func _physics_process(delta):
	#increment counters

	dash_time += delta
	dash_cool_time += delta
	attack_time += delta

	### MOVEMENT ###

	# Apply Gravity
	if !dashing:
		linear_vel += delta * GRAVITY_VEC
		
		# Move and Slide
		#linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		
		if linear_vel.y < 0:
			linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_FALL_MULT - 1) * delta
		elif linear_vel.y > 0 and !Input.is_action_pressed("jump"):
			linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_LOW_MULT - 1) * delta
	
	if dashing:
		linear_vel.y = 0
	#linear_vel += delta * GRAVITY_VEC
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	# Jumping
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		#$sound_jump.play()

	#on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###

	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("move_left"):
		target_speed += -1
	if Input.is_action_pressed("move_right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, ACCELERATION)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		linear_vel.x += DASH_SPD * sign(target_speed)
		dashing = true
		dash_time = 0
		dash_cool_time = 0
		can_dash = false
		
	if dash_time > DASH_DURATION:
		dashing = false
	
	if dash_cool_time > DASH_COOLDOWN:
		can_dash = true
		
	
	if Input.is_action_pressed("attack") and attack_time >= 0.6:
		attack_time = 0

	##ANIMTATION
	
	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			to_left()
			
		if linear_vel.x > SIDING_CHANGE_SPEED:
			to_right()
			
	else:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			to_left()
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			to_right()
			
			
	if attack_time < ATTACK_TIME_ANIM:
		new_anim = "attack"
		
	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)

func _on_OnFloor_body_entered(body):
	if body != self:
		on_floor = true

func _on_OnFloor_body_exited(body):
	if body != self:
		on_floor = false

func to_left():
	sprite.flip_h = true
	arma.rotation = PI
	
func to_right():
	sprite.flip_h = false
	arma.rotation = 0


func _on_Arma_Area_body_entered(body):
	if body.is_in_group("Atacavel"):
		body.dano()
