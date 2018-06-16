extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var SPEED
var stateAction = "stand"
#what
const FLOOR_NORMAL = Vector2(0, -1)

const WALKSPEED = 70;
const GRAVITY = Vector2(0, 600)
const RUNSPEED = 140
const JUMPSPEED = 280
const MIN_ONAIR_TIME = 0.1
var velocity = Vector2(0,0)
var onair_time = 0
var state = "small"
var on_floor = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):
	
	#big and small state setup
	if state == "big":
		$CollisionShape2D.disabled = false
		$CollisionShape2Dsmall.disabled = true
	else:
		$CollisionShape2D.disabled = true
		$CollisionShape2Dsmall.disabled = false
	#collision physics and all that jazz
	
	onair_time += delta

	
	if(velocity.y<600):
		velocity += delta *GRAVITY
		
	move_and_slide(velocity, FLOOR_NORMAL)
	if is_on_floor():
		onair_time = 0
	
	on_floor = onair_time < MIN_ONAIR_TIME

	#control
	var target_speed = 0
		#moveLeft
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.animation = state+"Walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
		if(velocity.x >-WALKSPEED):
			velocity.x -=2

		#b button
		if(velocity.x >-RUNSPEED && Input.is_action_pressed("ui_cancel")):
			velocity.x -=2

		#moveRight
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.animation = state+"Walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
		if(velocity.x <WALKSPEED):
			velocity.x +=2
				#b button
		if(velocity.x <RUNSPEED && Input.is_action_pressed("ui_cancel")):
			velocity.x +=2
		
		
	#stopright
	if Input.is_action_pressed("ui_left") && velocity.x>0:
			$AnimatedSprite.animation = state+"Stop"
			$AnimatedSprite.flip_h = velocity.x < 0
			deacelerate()
	#stopleft		
	if Input.is_action_pressed("ui_right") && velocity.x<0:
			$AnimatedSprite.animation = state+"Stop"
			$AnimatedSprite.flip_h = velocity.x < 0
			deacelerate()
	#jump
	
	if on_floor && Input.is_action_just_pressed("ui_accept"):
			$AnimatedSprite.animation = state+"Jump"
			$AnimatedSprite.flip_h = velocity.x < 0
			velocity.y = -JUMPSPEED
			
	if onair_time> 0.05:
			$AnimatedSprite.animation = state+"Jump"
			$AnimatedSprite.flip_h = velocity.x < 0
			
	#crouch
	if Input.is_action_pressed("ui_down") and state == "big":
		$AnimatedSprite.animation = "bigCrouch"
		$AnimatedSprite.flip_h = velocity.x < 0

	#returns to zero if no keys are pressed
	if !Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
		if (velocity.x != 0):
			deacelerate()
	
		
	#calls standing animation
	if velocity.x ==0 && on_floor:
		$AnimatedSprite.animation = state+"Stand"
		if Input.is_action_pressed("ui_down") and state == "big":
			$AnimatedSprite.animation = state+"Crouch"
			$AnimatedSprite.flip_h = velocity.x < 0
	
	if velocity.x >= 71 || velocity.x<=-71:
		$AnimatedSprite.get_sprite_frames().set_animation_speed(state+"Walk", 25)
	else:
		$AnimatedSprite.get_sprite_frames().set_animation_speed(state+"Walk", 12)
	
	$AnimatedSprite.play()

	
	move_and_slide(velocity * delta)
	$Label.text = "x"+String(velocity.x)+" y"+String(velocity.y)+" \n delta " +String(delta)
	
func deacelerate():
		if velocity.x >0:
			velocity.x =floor(velocity.x-2)
			if velocity.x <0:
				velocity.x=0
		else:
			velocity.x =floor(velocity.x+2)
			if velocity.x >0:
				velocity.x=0

	
func fall():
	velocity +=  GRAVITY