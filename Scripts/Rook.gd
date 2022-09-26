extends BasePiece

class_name Rook

func get_type():
	return "Rook"

func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]
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

	if type == "Enemy":
		var lower_x = tiles[0]
		var higher_x = tiles[0]
		var lower_y = tiles[0]
		var higher_y = tiles[0]

		for tile in tiles:
			if tile.x <= lower_x.x:
				lower_x = tile
			if tile.y <= lower_y.y:
				lower_y = tile
			if tile.x >= higher_x.x:
				higher_x = tile
			if tile.y >= higher_y.y:
				higher_y = tile
		
		return [lower_x, higher_x, lower_y, higher_y]

	return tiles
	
func move_to(var pos : Vector2):
	if boardScene.get_tile(pos).contains_opponent(type):
		#position = boardScene.board_position(pos)
		var enemy = boardScene.get_tile(pos).contains
		var damage : int = round(rand_range(min_damage, max_damage))
		var killed = enemy.take_damage(damage)
		if killed:
			.move_to(pos)
		else:
			#wait for a bit
			attacking = true
			.move_only_visual(pos)
			yield(self, "finished_internal_movement")
			var pushback = enemy.pushback(self, (pos - current_tile).normalized())
			enemy.push(self, (pos - current_tile).normalized())
			yield(enemy, "finished_push")
			if not pushback:
				.move_only_logic(pos)
			attacking = false
			GameManager.next_turn()
				
	else:
		.move_to(pos)


func attack(_original_position, _attack_position):
	attacking = true
	anim_start_movement(_original_position, _attack_position)
	yield(self, "finished_internal_movement")
	anim_start_movement(_attack_position, _original_position)
	yield(self, "finished_internal_movement")
	attacking = false
	emit_signal("finished_movement")
	if type == "Player":
		GameManager.next_turn()
