extends BasePiece

class_name Queen

export var counter_increase : int = 2
var counter : int = 0

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

			if boardScene.get_tile(next_tile).contains != null:
				if boardScene.get_tile(next_tile).contains != self and boardScene.get_tile(next_tile).contains_ally(type):
					tiles.remove(len(tiles)-1)
			if boardScene.get_tile(next_tile).contains_opponent(type):
				break
			next_tile += dir

	return tiles

func move_to(var pos : Vector2):
	if boardScene.get_tile(pos).contains_opponent(type):
		var attack_position = boardScene.board_position(pos)
		var damage : int = round(rand_range(min_damage + counter*counter_increase, max_damage + counter*counter_increase))
		var killed = boardScene.get_tile(pos).contains.take_damage(damage)
		if killed:
			.move_to(pos)
		else:
			.attack(boardScene.board_position(current_tile), attack_position)
			counter+=1
	else:
		.move_to(pos)
