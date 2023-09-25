extends CharacterBody2D

var SPEED := 300.0
var GRAVITY := 30.0
var JUMP := 600.0

@onready var animation_player := $AnimationPlayer

var speed
var gravity
var jump

var test : bool

enum {DOWN_LEFT = 1, DOWN = 2, DOWN_RIGHT = 3, LEFT = 4, NEUTRAL = 5, RIGHT = 6, UP_LEFT = 7, UP = 8, UP_RIGHT = 9}

func _get_local_input() -> Dictionary:
	var input := empty_input()
	
	var left: bool = Input.is_action_pressed("left")
	var right: bool = Input.is_action_pressed("right")
	var up: bool = Input.is_action_pressed("up")
	var down: bool = Input.is_action_pressed("down")
	
	var a: bool
	var b: bool
	var c: bool
	var d: bool
	
	var dir = NEUTRAL
	
#	if left and not right:
#		input['left'] = true
#
#	if right and not left:
#		input['right'] = true
#
#	if up:
#		input['up'] = true
#
#	elif down:
#		input['down'] = true
	
	if left and not right:
		dir -= 1
	
	if right and not left:
		dir += 1
	
	if up:
		dir += 3
	
	elif down:
		dir -= 3
	
	input['direction'] = dir
	
	return input

func empty_input() -> Dictionary:
	var input := {}
	
	input['left'] = false
	input['right'] = false
	input['up'] = false
	input['down'] = false
	
	input['a'] = false
	input['b'] = false
	input['c'] = false
	input['d'] = false
	
	return input

func _ready():	
	animation_player.assigned_animation = "Idle"
	animation_player.speed_scale = 1.0/60.0

func _physics_process(delta: float) -> void:
	_network_process(_get_local_input())

func _network_process(input: Dictionary):
	if input['direction'] == RIGHT and is_on_floor():
		if animation_player.assigned_animation != "Walk Forward":
			animation_player.stop()
			animation_player.assigned_animation = "Walk Forward"
			animation_player.advance(0)
		velocity.x = SPEED
	
	elif input['direction'] == LEFT and is_on_floor():
		velocity.x = -SPEED
	
	if input['direction'] == NEUTRAL and is_on_floor():
		if animation_player.assigned_animation != "Idle":
			animation_player.stop()
			animation_player.assigned_animation = "Idle"
			animation_player.advance(0)
		velocity.x = 0
	
	if input['direction'] >= 7 and is_on_floor():
		velocity.y = -JUMP
		if input['direction'] == UP_LEFT:
			velocity.x = -SPEED
		if input['direction'] == UP_RIGHT:
			velocity.x = SPEED
	
	
	
	velocity.y += GRAVITY
	move_and_slide()
	
	animation_player.advance(1)

