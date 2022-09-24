extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HP/Label.text = "HP: " + str(GameManager.player.hp) 
	if GameManager.player is Rook:
		$DMG/Label.text = "DMG: ?"
	else:
		$DMG/Label.text = "DMG: " + str(GameManager.player.min_damage) + " - " + str(GameManager.player.max_damage)


