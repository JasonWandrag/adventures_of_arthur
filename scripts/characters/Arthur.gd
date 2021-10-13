extends KinematicBody2D
# Variables
var velocity =  Vector2(0,0)
var speed = 350
var gravity = 30
var jump_force = -700
var is_attacking = false
var attack_num = 1
var attack_anim = null

func _physics_process(_delta):
	physics()
	input_actions()
	animation_state()

# Physics Engine
func physics():
	# Gravity / Vertical Movement
	velocity.y = velocity.y + gravity
	# Friction / Horizontal Movement
	velocity.x = lerp(velocity.x, 0, 0.3)
	# Apply Gravity and Friction to character
	velocity = move_and_slide(velocity, Vector2.UP)

# Movement
func input_actions():
	# Directional Movement
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed	
	# Jump Movement
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

# Sprites are named as following: name_action_age
func animation_state():
	# Check if Arthur is attacking or not
	if not is_attacking:
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
		# Attack animation
		if Input.is_action_just_pressed("attack"):
			melee_attack()

	# Animation Direction
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true

# Handle when animations finish
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "arthur_attack1_young" or $AnimatedSprite.animation == "arthur_attack2_young" or $AnimatedSprite.animation == "arthur_attack3_young":
		is_attacking = false

# Handle Melee logic
func melee_attack():
	is_attacking = true
	attack_anim = "arthur_attack" + str(attack_num) + "_young"
	$AnimatedSprite.play(attack_anim)
	attack_num = attack_num + 1
	if attack_num == 4:
		attack_num = 1	
