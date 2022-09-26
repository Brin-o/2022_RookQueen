extends BasePiece

class_name Bishop

func get_type():
	return "Bishop"

func can_move_to():
	var tiles : Array = []
	var opponent_tiles = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)]
	var next_tile = current_tile

	for dir in directions:
		next_tile = current_tile
		while boardScene.is_steppable(next_tile):
			if next_tile != current_tile:
				tiles.push_back(next_tile)
			if boardScene.get_tile(next_tile).contains != null and boardScene.get_tile(next_tile).contains != self:
				if boardScene.get_tile(next_tile).contains_opponent(type):
					opponent_tiles.push_back(next_tile)
				tiles.remove(len(tiles)-1)
				break
			next_tile += dir

	if len(tiles) == 0:
		return opponent_tiles

	if type == "Enemy":
		tiles = boardScene.get_closest_tiles_to_player(tiles)

	return tiles


func move_to(var pos : Vector2):
	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]

	#NOT AOE
	if boardScene.get_tile(pos).contains_opponent(type):
		var attack_position = boardScene.board_position(pos)
		var damage : int = round(rand_range(min_damage, max_damage))
		var killed = boardScene.get_tile(pos).contains.take_damage(damage)
		if killed:
			.move_to(pos)
		else:
			.attack(boardScene.board_position(current_tile), attack_position)


	else: #AOE
		attacking = true
		.move_no_turn(pos)
		yield(self, "finished_internal_movement")
		for dir in directions:
			var attack_pos = pos + dir
			if boardScene.is_inbounds(attack_pos):
				if boardScene.get_tile(attack_pos).contains_opponent(type):
					var damage : int = round(rand_range(min_damage, max_damage))
					var killed = boardScene.get_tile(attack_pos).contains.take_damage(damage)
					print("Checking killed")
					#$SpritePivot.x_scale = 2
					#yield(get_tree().create_timer(0.5), "timeout")
					attacking = false
		emit_signal("finished_movement")			
		attacking = false
		if type == "Player":
			#yield(self, "finished_movement")
			GameManager.next_turn()
