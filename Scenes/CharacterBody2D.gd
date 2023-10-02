extends CharacterBody2D

class_name FGCharacter

var SPEED := 300.0
var GRAVITY := 30.0
var JUMP := 600.0

@onready var animation_player := $AnimationPlayer
@onready var movelist : MoveList = $Moves

var moves := { }

var speed
var gravity
var jump

var test : bool

var current_move : Move
# The moves you can cancel into
# TODO set the keys to inputs instead, to prevent hardcoding
var cancel_options := { }
# The moves that have already been cancelled into
var move_chain := [ ]

enum {DOWN_LEFT = 1, DOWN = 2, DOWN_RIGHT = 3, LEFT = 4, NEUTRAL = 5, RIGHT = 6, UP_LEFT = 7, UP = 8, UP_RIGHT = 9}

enum Moves {ALL, GROUND_MOVEMENT, JUMP}

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
	movelist.change_move("Idle")
	animation_player.speed_scale = 1.0/60.0
	

func _physics_process(delta: float) -> void:
	_network_process(_get_local_input())

func _network_process(input: Dictionary):
	var stored_move = current_move
	if input['direction'] == RIGHT and can_cancel(&"6"):
		#if animation_player.assigned_animation != "Walk Forward":
		#	animation_player.stop()
		#	animation_player.assigned_animation = "Walk Forward"
		#	animation_player.advance(0)
		#velocity.x = SPEED
		movelist.change_move(cancel_options[&"6"].name)
		
	
	if input['direction'] == LEFT and can_cancel(&"4"):
		movelist.change_move(cancel_options[&"4"].name)
	
	if input['direction'] == NEUTRAL and can_cancel(&"5"):
		movelist.change_move(cancel_options[&"5"].name)
	
	if input['direction'] == UP_LEFT and can_cancel(&"7"):
		movelist.change_move(cancel_options[&"7"].name)
	
	if input['direction'] == UP and can_cancel(&"8"):
		movelist.change_move(cancel_options[&"8"].name)
	
	if input['direction'] == UP_RIGHT and can_cancel(&"9"):
		movelist.change_move(cancel_options[&"9"].name)
	
	movelist.tick()
	
	velocity.y += GRAVITY
	move_and_slide()

func set_cancels(arr: Array, _exc_arr := []):
	var to_set = { }
	
	for move in movelist.get_children():
		for item in arr:
			if _is_move(move, item) and !move_chain.has(move.input) and !_exc_arr.has(move):
				to_set[move.input] = move
				break;
	
	cancel_options = to_set
	
	print(to_set)

func _is_move(move:Move, data) -> bool:
	if data is Move:
		return data.equals(move.name);
	if data == Moves.ALL:
		return true
	if data == Moves.GROUND_MOVEMENT and move.is_in_group(&"Ground Movement"):
		return true
	if data == Moves.JUMP and move.is_in_group(&"Jump"):
		return true
	return false

func can_cancel(input: StringName) -> bool:
	return cancel_options.has(input)
