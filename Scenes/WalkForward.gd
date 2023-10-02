extends Move

func _on_start():
	player.set_cancels([FGCharacter.Moves.GROUND_MOVEMENT, FGCharacter.Moves.JUMP])
	player.velocity.x = player.SPEED
