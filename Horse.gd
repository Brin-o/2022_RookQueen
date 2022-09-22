extends BasePiece

class_name Horse


func can_move_to():
	var tiles : Array = []

	var pos = Vector2(current_tile.x-1, current_tile.y-2)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x-2, current_tile.y-1)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x-1, current_tile.y+2)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x-2, current_tile.y+1)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x+1, current_tile.y-2)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x+2, current_tile.y-1)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x+1, current_tile.y+2)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	pos = Vector2(current_tile.x+2, current_tile.y+1)
	if boardScene.is_steppable(pos):
		tiles.push_back(pos)

	return tiles