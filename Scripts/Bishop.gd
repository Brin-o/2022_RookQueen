extends BasePiece

class_name Bishop

func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)]
	var next_tile = current_tile

	for dir in directions:
		next_tile = current_tile
		while boardScene.is_steppable(next_tile):
			if next_tile != current_tile:
				tiles.push_back(next_tile)
			if boardScene.get_tile(next_tile).contains != null and boardScene.get_tile(next_tile).contains != self:
				tiles.remove(len(tiles)-1)
				break
			next_tile += dir

	return tiles


func move_to(var pos : Vector2):
	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]
	.move_no_turn(pos)

	for dir in directions:
		var attack_pos = pos + dir
		if boardScene.is_inbounds(attack_pos):
			if boardScene.get_tile(attack_pos).contains_opponent(type):
				var damage : int = round(rand_range(min_damage, max_damage))
				var killed = boardScene.get_tile(attack_pos).contains.take_damage(damage)
    
	if type == "Player":
		yield(self, "finished_movement")
		GameManager.next_turn()