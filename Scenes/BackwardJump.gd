extends Move

func _on_start():
	player.set_cancels([])
	player.velocity = Vector2(-player.SPEED, -player.JUMP)
