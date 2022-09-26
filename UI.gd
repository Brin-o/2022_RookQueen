extends Node2D

func _ready():
	GameManager.ui = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(GameManager.player):
		$HP/Label.text =  str(GameManager.player.hp) 
		if GameManager.player is Rook:
			$DMG/Label.text = "?"
		else:
			$DMG/Label.text = str(GameManager.player.min_damage) + "-" + str(GameManager.player.max_damage)
	else:
		$HP/Label.text = "YOU"
		$DMG/Label.text = "DIED"

	if is_instance_valid(GameManager.board):
		$LVL/Label.text = "LVL: " + str(GameManager.level.num)

		if GameManager.level.num == 1 or GameManager.level.num == 11:
			visible = false
		else:
			visible = true
	pass
