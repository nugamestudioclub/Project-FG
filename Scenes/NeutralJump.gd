extends Move

func _on_start():
	player.set_cancels([])
	player.velocity = Vector2(0, -player.JUMP)

# TODO change this to universal behavior
func _on_tick():
	if player.is_on_floor() and frame > 3:
		controller.change_move("Idle")
