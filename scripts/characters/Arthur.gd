extends KinematicBody2D

# Variables to code
var velocity =  Vector2(0,0)
var speed = 200
var gravity = 30
var jump_force = -850

# Code to run 60 times per second
func _physics_process(delta):
	physics()
	movement()


# Physics Engine
func physics():
	velocity.y = velocity.y + gravity
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity = move_and_slide(velocity, Vector2.UP)


# Movement States ::NEED TO REVISE
func movement():
	# Left/Right movement
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimatedSprite.play("arthur_run_young")
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimatedSprite.play("arthur_run_young")
	
	# Idle Movement
	if is_on_floor():
		$AnimatedSprite.play("arthur_idle_young")
	
	# Jump Movement
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
