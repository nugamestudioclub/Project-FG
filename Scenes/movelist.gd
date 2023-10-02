extends Node

class_name MoveList

var current_move: Move

func change_move(move: String) -> void:
	var move_node : Move = get_node(move)
	if current_move != move_node:
		if current_move:
			current_move.end()
		current_move = move_node
		current_move.begin()

func tick() -> void:
	current_move.play()
