extends KinematicBody2D
# Signals
signal grounded_updated(is_grounded)
# Camera Controls
onready var prev_camera_pos = $Camera2D.get_camera_position()
onready var tween = $Camera2D/Tween
var facing = 0
const look_ahead = 0.25
const shift_trans = Tween.TRANS_SINE
const shift_ease = Tween.EASE_OUT
const shift_duration = 0.8
# Variables
var velocity =  Vector2(0,0)
var accel = 15
const max_accel = 700
var gravity = 30
var jump_force = -700
var jump_step = 0
var jump_max = 1
var is_attacking = false
var is_grounded = false
var attack_num = 1
var attack_anim = null
# Game Feel aka The Juice
onready var coyote_timer = $CoyoteTimer


func _physics_process(_delta):
	physics()
	input_actions()
	animation_state()
	camera_state()

# Physics Engine
func physics():
	# Gravity / Vertical Movement
	velocity.y = velocity.y + gravity
	# Friction / Horizontal Movement
	velocity.x = clamp(velocity.x, -max_accel, max_accel)
	# Apply Gravity and Friction to character
	$Debugger/UI/RichTextLabel.text = str(velocity.x)
	print(str(velocity.x))
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
		coyote_timer.start()

# Movement
func input_actions():
	# Directional Movement
	if Input.is_action_pressed("right"):
		velocity.x += accel
	elif Input.is_action_pressed("left"):
		velocity.x -= accel
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
	# Jump Movement
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() or jump_step < jump_max or !coyote_timer.is_stopped()):
			coyote_timer.stop()
			jump_step = jump_step + 1
			velocity.y = jump_force

# Sprites are named as following: name_action_age
func animation_state():
	# Check if Arthur is attacking or not
	if not is_attacking:
		# On Floor Animation
		if is_on_floor():
			if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
				if (velocity.x < (-max_accel + 100) or velocity.x > (max_accel - 100)):
					$AnimatedSprite.play("arthur_sprint_young")
					accel = 25
				else:
					$AnimatedSprite.play("arthur_run_young")
					accel = 15
			else:
				$AnimatedSprite.play("arthur_idle_young")
		
		# In Air Animation
		if not is_on_floor():
			if velocity.y < 0:
				if jump_step == 0:
					$AnimatedSprite.play("arthur_jump_young")
				else:
					$AnimatedSprite.play("arthur_roll_young")
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

# Camera
func camera_state():
	check_facing()
	prev_camera_pos = $Camera2D.get_camera_position()
	
	
func check_facing():
	var new_facing = sign($Camera2D.get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * look_ahead * facing
		#tween.interpolate_property($Camera2D, "position: x", $Camera2D.position.x, target_offset, shift_duration, shift_trans, shift_ease)
		#tween.start()
		$Camera2D.position.x = target_offset
	
func _on_Arthur_grounded_updated(is_grounded):
	$Camera2D.drag_margin_v_enabled = !is_grounded
	jump_step = 0
