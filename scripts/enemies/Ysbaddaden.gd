extends KinematicBody2D

# Ysbadadden Settings
var gravity = 10
var velocity = Vector2(0,0)
var speed = 64
var jump_force = -850
var is_moving_right = true

func _ready():
	$AnimatedSprite.play("Walk")

	
func _physics_process(delta):
	move_character()
	detect_turn_around()

func move_character():
	velocity.x = speed if is_moving_right else -speed;
	velocity.y += gravity;
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
