extends KinematicBody2D

export (int) var SPEED
const FLOOR_NORMAL = Vector2(0, -1)
const WALKSPEED = -20;
const GRAVITY = Vector2(0, 200)
var velocity = Vector2(WALKSPEED, 0)
var state = "alive"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


var a = 0
func _process(delta):
	if(velocity.y< GRAVITY.y) && state == "alive":
		velocity += delta *GRAVITY
	
	if state == "alive":
		move_and_slide(velocity, FLOOR_NORMAL)
	
		move_and_slide(velocity * delta)
	
	if !$up.is_colliding() && state == "alive":
		$AnimatedSprite.animation = "default"
		$Label.text = "not dead"
	elif !state == "hidden":
		$Label.text = "dead"
		state = "dead"
		$AnimatedSprite.animation = "death"
		$CollisionShape2D.disabled= true
		velocity = Vector2(0,0)
		
		a+=delta;
		if a > 1:
			state = "hidden"
			hide()
			$Label.text = "aaaa"
			$Label.show()
	
	
	$AnimatedSprite.play()
	
