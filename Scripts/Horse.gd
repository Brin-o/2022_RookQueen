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

func move_to(var pos : Vector2):
	if boardScene.get_tile(pos).contains_opponent(type):
		position = boardScene.board_position(pos)
		var killed = boardScene.get_tile(pos).contains.take_damage(damage)
		if killed:
			#Change position and be able to move again
			print("You killed as a horse, you get another turn!")
			boardScene.set_tile_piece(current_tile, null)
			current_tile = pos
			position = boardScene.board_position(pos)
			boardScene.set_tile_piece(current_tile, self)
			pass
		else:
			position = boardScene.board_position(current_tile)
	else:
		.move_to(pos)