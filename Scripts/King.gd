extends BasePiece

class_name King

func get_type():
	return "King"

func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1),
					  Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]

	for dir in directions:
		var tile = current_tile + dir
		if boardScene.is_steppable(tile) and boardScene.get_tile(tile).contains == null:
			tiles.push_back(tile)

	return tiles

func move_to(var pos : Vector2):
	.move_no_turn(pos)
	summon()
	if type == "Player":
		yield(self, "finished_movement")
		GameManager.next_turn()
	

func summon():
	var empty_tiles : Array = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1),
					  Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]

	for dir in directions:
		var tile = current_tile + dir
		if boardScene.is_steppable(tile) and boardScene.get_tile(tile).contains == null:
			empty_tiles.push_back(tile)
	
	var spawn_at = empty_tiles[randi() % empty_tiles.size()]
	
	boardScene.spawn_piece("H", spawn_at)