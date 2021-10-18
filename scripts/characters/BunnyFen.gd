extends KinematicBody2D

const GRAVITY = 100
const UP = Vector2.UP

var vel = Vector2()
var speed = 100
var jump = 250
var m_left = true
var has_jumped = false


var rng = RandomNumberGenerator.new()
onready var l_ray = $l_ray

func _ready():
	rng.randomize()
	speed = rng.randi_range(80, 200)
	jump = rng.randi_range(150, 300)

# This function is called every physics frame
func _physics_process(_delta):
	
	vel.y = +GRAVITY
	
	if l_ray.is_colliding():
		rng.randomize()
		if is_on_floor() and rng.randi_range(0, 10.0) > 2:
			has_jumped = true
		else:
			has_jumped = false
			m_left = !m_left
			scale.x = -scale.x
	
	vel.x = -speed if m_left else speed

	if (has_jumped):
		vel.y = -jump


	if vel.x != 0:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

		
	vel = move_and_slide(vel, UP)
	

