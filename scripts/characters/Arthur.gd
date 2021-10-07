extends KinematicBody2D





# Variables
var velocity =  Vector2(0,0)
var speed = 200
var gravity = 30
var jump_force = -850











# Code to run 60 times per second
func _physics_process(delta):
	physics()
	movement()
	animation_state()










# Physics Engine
func physics():
	velocity.y = velocity.y + gravity
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity = move_and_slide(velocity, Vector2.UP)










# Movement States ::NEED TO REVISE
func movement():
	# Direction State
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed	
	# Jump Movement
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force














func animation_state():
	# On Floor Animation
	if is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			$AnimatedSprite.play("arthur_run_young")
		else:
			$AnimatedSprite.play("arthur_idle_young")
	
	# In Air Animation
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite.play("arthur_jump_young")
		elif velocity.y > 0:
			$AnimatedSprite.play("arthur_fall_young")
	
	# Animation Direction
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
