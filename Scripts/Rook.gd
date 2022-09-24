extends BasePiece

class_name Rook

func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]
	var next_tile = current_tile

	for dir in directions:
		next_tile = current_tile
		while boardScene.is_steppable(next_tile):
			if next_tile != current_tile:
				tiles.push_back(next_tile)
			if boardScene.get_tile(next_tile).contains_opponent(type):
				break
			next_tile += dir

	return tiles
	
func move_to(var pos : Vector2):
	if boardScene.get_tile(pos).contains_opponent(type):
		position = boardScene.board_position(pos)
		var enemy = boardScene.get_tile(pos).contains
		var damage:int = round(rand_range(min_damage, max_damage))
		var killed = enemy.take_damage(damage)
		if killed:
			.move_to(pos)
		else:
			#wait for a bit
			var can_move_to_enemy_place = enemy.push(self, (pos - current_tile).normalized())
			if can_move_to_enemy_place:
				print("Moving to")
				.move_to(pos)
	else:
		.move_to(pos)
