extends BasePiece

class_name Queen

func get_type():
	return "Queen"

var base_min_dmg = min_damage
var base_max_dmg = max_damage

export var counter_increase : int = 1
var counter : int = 0

var buff = load("res://Scenes/Partial/BuffPopup.tscn")


func can_move_to():
	var tiles : Array = []

	var directions = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1),
					  Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]
	var next_tile = current_tile

	for dir in directions:
		next_tile = current_tile
		while boardScene.is_steppable(next_tile):
			if type == "Enemy" and boardScene.get_tile(next_tile).contains_player():
				return [next_tile]

			if next_tile != current_tile:
				tiles.push_back(next_tile)

			if boardScene.get_tile(next_tile).contains != null:
				if boardScene.get_tile(next_tile).contains != self and boardScene.get_tile(next_tile).contains_ally(type):
					tiles.remove(len(tiles)-1)
			if boardScene.get_tile(next_tile).contains_opponent(type):
				break
			next_tile += dir
	
	if type == "Enemy":
		tiles = boardScene.get_closest_tiles_to_player(tiles)
	
	return tiles

func move_to(var pos : Vector2):
	if boardScene.get_tile(pos).contains_opponent(type):
		var attack_position = boardScene.board_position(pos)
		var damage : int = round(rand_range(min_damage, max_damage))
		var killed = boardScene.get_tile(pos).contains.take_damage(damage)
		if killed:
			.move_to(pos)
		else:
			.attack(boardScene.board_position(current_tile), attack_position)
			counter+=1
	else:
		.move_to(pos)
	counter+=1
	min_damage = base_min_dmg + counter*counter_increase
	max_damage = base_max_dmg + counter*counter_increase
	var b = buff.instance()
	add_child(b)
	b.hp_pop(self)
	
