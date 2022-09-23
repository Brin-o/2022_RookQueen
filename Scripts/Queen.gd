extends BasePiece

class_name Queen

func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1),
					  Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]
	var next_tile = current_tile

	for dir in directions:
		next_tile = current_tile
		while boardScene.is_steppable(next_tile):
			if next_tile != current_tile:
				tiles.push_back(next_tile)
			if boardScene.get_tile(next_tile).contains_enemy():
				break
			next_tile += dir

	return tiles