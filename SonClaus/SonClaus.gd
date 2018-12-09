extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 500 # pixels/sec
const ACCELERATION = 0.2

#Jumps
const JUMP_SPEED = 650
const JUMP_FALL_MULT = 2.5
const JUMP_LOW_MULT = 2.0

const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time=99999 #time since last shot

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func _physics_process(delta):
	#increment counters

	onair_time += delta
	shoot_time += delta

	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	
	# Move and Slide
	#linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	if linear_vel.y < 0:
		linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_FALL_MULT - 1) * delta
	elif linear_vel.y > 0 and !Input.is_action_pressed("jump"):
		linear_vel += Vector2(0, 1) * GRAVITY_VEC.y * (JUMP_LOW_MULT - 1) * delta
		
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

	##ANIMTATION

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = toNeg(sprite.scale.x)
			
		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = toPos(sprite.scale.x)
			
	else:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			sprite.scale.x = toNeg(sprite.scale.x)
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			sprite.scale.x = toPos(sprite.scale.x)

func _on_OnFloor_body_entered(body):
	on_floor = true

func _on_OnFloor_body_exited(body):
	on_floor = false

func toPos(n):
	if n < 0:
		return n*-1
	else:
		return n
		
func toNeg(n):
	if n > 0:
		return n*-1
	else:
		return n
