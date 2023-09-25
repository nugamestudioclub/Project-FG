extends CharacterBody2D

const SPEED = 200
const GRAVITY = 10
const JUMP = 300

func _ready():
	# up_direction = SGFixed.vector2(0, -65536)
	up_direction = Vector2(0, -1)

func _physics_process(delta: float) -> void:
	var x_motion: int = SGFixed.from_float(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	velocity.x = SGFixed.mul(x_motion, SPEED)

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP

	velocity.y += GRAVITY
	move_and_slide()
		

